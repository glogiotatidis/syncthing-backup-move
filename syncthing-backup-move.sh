#!/bin/bash
#
# Simple bash script to move things from SYNC_FOLDER to BACKUP_FOLDER
# when syncthing is idle on $SYNCTHING_FOLDER
#
# http://syncthing.net/
#
if [[ -z "$SYNCTHING_FOLDER" ]]; then
    echo "Set SYNCTHING_FOLDER"
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

curl -s http://localhost:8080/rest/model?folder=$SYNCTHING_FOLDER  | grep  '"state":"idle"' > /dev/null;

if [ $? -eq 1 ]; then
   echo "Not idle";
   exit;
fi

echo "Moving"
rsync --recursive $SYNC_FOLDER/* $BACKUP_FOLDER
rm -rf $SYNC_FOLDER/*
