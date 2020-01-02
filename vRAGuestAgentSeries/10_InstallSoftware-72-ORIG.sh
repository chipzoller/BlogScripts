#!/bin/bash

############################################
# Script for the task "InstallSoftware"    #
# Date: 28/04/2009                         #
# Author: Arnaud Bonnet & Anton S          #
############################################

# Load script with common functions
# if it occurs an error, exit with code 3
#source ../scripts/default/Common_Functions.sh || exit 3

# Check if needs to run external script
PropertyValue=$(python getprop.py Vrm.Software.Command)
NoErrors=$(python getprop.py Vrm.InstallSoftware.NoErrors)

FILE_HDR="[VRMAgent::$0]"

myrv=0

if [ "$PropertyValue" != "False" ];then
    sleep 10

    if [ -f "$PropertyValue" ]; then
        FILE_NAME="$PropertyValue"
    else
        FILE_NAME=`echo "$PropertyValue" | cut -f1 -d' '`
        if [ ! -f $FILE_NAME ]; then
            echo "Cannot find script $PropertyValue" > /usr/share/gugent/site/InstallSoftware/gugenterror.txt
            logger "$FILE_HDR (ERROR): Cannot find script $PropertyValue"
            logger "$FILE_HDR (INFO - Mount): `mount`"
            logger "$FILE_HDR (INFO - Ls): `ls -la $PropertyValue`"
            exit 2
        fi
    fi

    #Below code modifies the path of script to be executed if 'VirtualMachine.ScriptPath.Decrypt' is set to 'true'
    #Check value of path decryption enabled field
    encPath=$(python getprop.py VirtualMachine.ScriptPath.Decrypt)
    if [ $encPath = "True" -o $encPath = "true" ]; then
       #extract encrypted field names from PropertyValue
       var_names=$(echo $PropertyValue | awk 'NR>1{print $1}' RS=[ FS=])
       #for each var_names, check if it exists from getprop.py
       for var_name in $var_names
       do
          dec_val=$(python getprop.py $var_name)
          if [ "$dec_val" != "False" ]; then
              PropertyValue=$(echo "$PropertyValue" | sed "s/\[$var_name\]/$dec_val/g")
          else
              logger "$FILE_HDR (ERROR): Cannot find custom property $var_name"
              exit 3
          fi
       done
    fi

    if [ -x $FILE_NAME ]; then
        # Executable version does not return the exit code
        if [ "$NoErrors" != "False" ]; then
            $PropertyValue
        else
            $PropertyValue > gugenterror.txt 2>&1
        fi
        myrv=$?
    else
        if [ -z $SHELL ]; then
            if [ "$NoErrors" != "False" ]; then
                /bin/bash $PropertyValue
            else
                /bin/bash $PropertyValue > gugenterror.txt 2>&1
            fi
        else
            if [ "$NoErrors" != "False" ]; then
                $SHELL $PropertyValue
            else
                $SHELL $PropertyValue > gugenterror.txt 2>&1
            fi
        fi
        rv=$?
        if [ $rv -eq 0 ]; then
            logger "$FILE_HDR (INFO): $SHELL $PropertyValue executed successfully"
        else
            logger "$FILE_HDR (ERROR): $SHELL $PropertyValue failed, error code: $rv"
            myrv=8
        fi
    fi
    sleep 5
    logger "$FILE_HDR (INFO): Unmounting all CD and DVD drives"
    umount -af -t iso9660
    sleep 5
fi

exit $myrv
