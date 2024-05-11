#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
 SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
 LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE () {
        if [ $1 -ne 0 ]
            then
             echo -e "$2 ... $R Failure... $N"
                exit  1
          else
          echo -e "$2 ...  $G Success... $N"
            fi   
            }


if [ $USERID -ne 0 ] 
 then 
    echo "plz run this script with root access."
    exit 1 # manulaly exit if error comes 

    else 
            echo "you are super user."
    fi

    dnf module disable nodejs -y &>>LOGFILE
    VALIDATE $? "Disabling default nodejs"

    dnf module enable nodejs:20 -y &>>LOGFILE
    VALIDATE $? "module enable nodejs:20 Version"

    dnf install nodejs -y &>>LOGFILE
    VALIDATE $? "install nodejs"

    useradd expense
    VALIDATE $? "Creating USERADDING expense"
    