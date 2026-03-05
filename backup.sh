#!bin/bash
USERID=$(id -u)
LOG_FOLDER="/var/log/shell-script"
LOG_FILE="$LOG_FOLDER/backup.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"
SCRIPT_DIR=$PWD
MONGODB_HOST=mongodb.devcops.online

if [ $cartID -ne 0 ]; then
     echo -e "$R please run this script using root user $N"  
fi

mkdir -p $LOG_FOLDER

USAGE(){
    echo -e "$R USAGE:: sudo backup <SOURCE_DIR> <DEST_DIR> <DAYS>(deafult 14 days) $N"
    exit 1
}


if [ $# -le 2]; then 
    USAGE