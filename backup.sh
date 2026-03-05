#!bin/bash
USERID=$(id -u)
LOG_FOLDER="/var/log/shell-script"
LOG_FILE="$LOG_FOLDER/backup.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"
SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} # default is 3 if not value is not given.

if [ $USERID -ne 0 ]; then
     echo -e "$R please run this script using root user $N"  
fi

mkdir -p $LOG_FOLDER

USAGE(){
    echo -e "$R USAGE:: sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>(deafult 14 days) $N"
    exit 1
}


log(){
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | $1" | tee -a $LOG_FILE
}

if [ $# -lt 2 ]; then 
    USAGE
fi

if [ ! -d $SOURCE_DIR ]; then
     echo -e "$R source dir $SOURCE_DIR does not exitst  $N"
     exit 1
fi 

if [ ! -d $DEST_DIR ]; then
     echo -e "$R destintion dir $DEST_DIR does not exitst  $N"
     exit 1
fi 


FILES=$(find $SOURCE_DIR ".log" type -f -mtime  +$DAYS)

log "backup started"
log " SOURCE DIR: $SOURCE_DIR"
log " DEST DIR: $DEST_DIR"
log " NO.OF DAYS : $DAYS"

if [ -z $FILES]; then
    log "NO FILES TO ARECHIVE.... $Y SKIPPING $N"
fi



