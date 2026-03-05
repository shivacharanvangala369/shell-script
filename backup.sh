#!/bin/bash
USERID=$(id -u)
LOG_FOLDER="/var/log/shell-script"
LOG_FILE="$LOG_FOLDER/backup.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # default is 14 if not value is not given.

log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOG_FILE
}


if [ $USERID -ne 0 ]; then
      echo -e "$R Please run this script with root user access $N"
      exit 1
fi

mkdir -p $LOG_FOLDER

USAGE(){
    log -e "$R USAGE:: sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>(deafult 14 days) $N"
    exit 1
}


if [ $# -lt 2 ]; then 
    USAGE
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log "$R Source Directory: $SOURCE_DIR does not exist $N"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    log "$R Destination Directory:  $DEST_DIR does not exist $N"
    exit 1
fi

### Find the files
FILES=$(find $SOURCE_DIR -name "*.log" -type f -mtime  +$DAYS)

log "backup started"
log "SOURCE DIR: $SOURCE_DIR"
log "DEST DIR: $DEST_DIR"
log "NO.OF DAYS : $DAYS"

if [ -z "${FILES}" ]; then
    log "NO FILES TO ARECHIVE.... $Y SKIPPING $N"
else
   log "FILES FOUND TO ARECHIVE: $FILES "
   TIMESTAMP=$(date +%F-%H-%M-%S)
   ZIP_FILE_NAME="$DEST_DIR/app-logs.$TIMESTAMP.tar.gz"
   log "ARchive name: $ZIP_FILE_NAME"
   tar -zcvf $ZIP_FILE_NAME $FILES


   # CHECK ARECHIVE IS SUCESS OR NOT
   if [ -f $ZIP_FILE_NAME ]; then
        log "arechival is.... $G SUCCESS $N"

        while IFS= read -r filepath; do
        log "Deleting file: $filepath"
        rm -f $filepath
        log "Deleted file: $filepath"
        done <<< $FILES

   else
         log "arechival is.... $R FAILUR $N"
         exit 1
    fi

fi





