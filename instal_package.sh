#!/bin/bash

USERID=$(id -u)
LOG_FOLDER="/var/log/install_packages"
LOG_FILE="/var/log/install_packages/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[34m"



if [ $USERID -ne 0 ]; then
     echo -e "$R please run this script using root user" | tee -a $LOG_FILE
     exit 1
fi

mkdir -p $LOG_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e " $2... $R FAILURE" | tee -a $LOG_FILE
    else
        echo -e "$2... $G SUCCESS" | tee -a $LOG_FILE
    fi
}

for package in $@
do  
  dnf list installed $package  &>>$LOG_FILE
  if [ $? -ne 0 ];then
    echo -e "$package  $Y is not installed on system, Installing Now"
    dnf install $package -y &>>$LOG_FILE
    VALIDATE  $? "$package  installation"
  else
    echo -e " $package $Y is alraedy installed on system $N "
  fi
done