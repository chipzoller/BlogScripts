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
FILE_HDR="[VRMAgent::$0]"

myrv=0

if [ "$PropertyValue" != "False" ];then
    sleep 10
        if [ -x "$PropertyValue" ]; then
            . $PropertyValue
        else
            eval $PropertyValue
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
exit $myrv