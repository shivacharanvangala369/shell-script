#!/bin/bash

LOG_DIR=/home/ec2-user/app-logs
LOG_FILE="$LOG_DIR/$0.log"

if [  ! -d $LOG_DIR ]; then
    echo -e "$LOG_DIR is not exitst"
    exit 1
fi

FILE_TO_DELETE=$(find $LOG_DIR -name "*.log" -mtime +14)
#echo "$FILE_TO_DELETE"

while IFS=read -r filepath; do
    echo -e "deleteing files: $filepath"
    rm -f $filepath
    echo -e "deleted files: $filepath"
done <<< $FILE_TO_DELETE
