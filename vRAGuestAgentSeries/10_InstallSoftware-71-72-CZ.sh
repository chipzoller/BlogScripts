#!/bin/bash

############################################
# Script for the task "InstallSoftware"    #
# Date: 28/04/2009                         #
# Author: Arnaud Bonnet & Anton S          #
# Modified by:  Chip Zoller & Josh McCartt #
############################################

# Load script with common functions
# if it occurs an error, exit with code 3
#source ../scripts/default/Common_Functions.sh || exit 3

# Check if needs to run external script
EscapedString=$(python getprop.py Vrm.Software.Command)
PropertyValue=`echo "$EscapedString" | sed -e 's~\&amp;~\&~g' -e 's~\&lt;~<~g'  -e  's~\&gt;~>~g' -e 's~\&gt;~>~g' -e 's~\&quot;~\"~g' -e "s~\&apos;~\'~g"`

NoErrors=$(python getprop.py Vrm.InstallSoftware.NoErrors)

FILE_HDR="[VRMAgent::$0]"

myrv=0

if [ "$PropertyValue" != "False" ];then
    sleep 10

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

    if [ -x "$PropertyValue" ]; then
        # Executable version does not return the exit code
        if [ "$NoErrors" != "False" ]; then
            eval $PropertyValue
        else
            eval $PropertyValue > gugenterror.txt 2>&1
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
                eval $PropertyValue
            else
                eval $PropertyValue > gugenterror.txt 2>&1
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
