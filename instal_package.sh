#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/install_packages"
LOG_FILE="/var/log/install_packages/$0.log"

if [ $USERID -ne 0 ]; then
     echo " please run this script using root user" | tee -a $LOG_FILE
     exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "$2... FAILURE" | tee -a $LOG_FILE
    else
        echo "$2... SUCCESS" | tee -a $LOG_FILE
    fi
}

for package in $@
do  
  dnf list installed $package  &>>$LOG_FILE
  if [ $? -ne 0 ];then
    echo "$package is not installed on system, Installing Now"
    dnf install $package -y &>>$LOG_FILE
    VALIDATE $? "$package installation"
  else
    echo "$package is alraedy installed on system"
  fi
done