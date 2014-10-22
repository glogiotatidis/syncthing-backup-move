#!/bin/bash
#
# Simple bash script to move things from SYNC_FOLDER to BACKUP_FOLDER
# when syncthing (pulse) [0] is idle on $PULSE_FOLDER
#
# [0] https://ind.ie/pulse/
#
if [[ -z "$PULSE_FOLDER" ]]; then
    echo "Set PULSE_FOLDER"
    exit;
fi

if [[ -z "$SYNC_FOLDER" ]]; then
    echo "Set SYNC_FOLDER"
    exit;
fi

if [[ -z "$BACKUP_FOLDER" ]]; then
    echo "Set BACKUP_FOLDER"
    exit;
fi

curl -s http://localhost:8080/rest/model?folder=$PULSE_FOLDER  | grep  '"state":"idle"' > /dev/null;

if [ $? -eq 1 ]; then
   echo "Not idle";
   exit;
fi

echo "Moving"
rsync --recursive $SYNC_FOLDER/* $BACKUP_FOLDER
rm -rf $SYNC_FOLDER/*
