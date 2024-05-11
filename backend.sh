#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
 SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
 LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"




echo "Please enter DB password"
read -s mysql_root_password

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

    dnf module disable nodejs -y &>>$LOGFILE
    VALIDATE $? "Disabling default nodejs"

    dnf module enable nodejs:20 -y &>>$LOGFILE
    VALIDATE $? "module enable nodejs:20 Version"

    dnf install nodejs -y &>>$LOGFILE
    VALIDATE $? "installing  nodejs"

    # useradd expense
    # VALIDATE $? "Creating USERADDING expense"

    id expense &>>$LOGFILE
    if [ $? -ne 0 ]
    then
    useradd expense &>>$LOGFILE
    VALIDATE $? "creating expense user"
    else
    echo -e "Expense user already created ... $Y SKIPPING $N"
    fi
    

    mkdir -p /app &>>$LOGFILE  
    VALIDATE $? "Creating app directory"

    curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE 
    VALIDATE $? "Downloading backend code"

    cd /app 
    unzip /tmp/backend.zip &>>$LOGFILE 
    VALIDATE $? "Extracted backed code"

    npm install -y  &>>$LOGFILE
    VALIDATE $? "installing nodejs dependencies"

    #backend.service
    cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backed.service

    VALIDATE $? "Copied backed service"

    systemctl daemon-reload &>>$LOGFILE
    VALIDATE $? "daemon-reload"

    systemctl start backend &>>$LOGFILE
    VALIDATE $? "daemon-reload"
    
    systemctl enable backend &>>$LOGFILE
    VALIDATE $? "enable backend"

    
    
    dnf install mysql -y &>>$LOGFILE
    VALIDATE $? "Installing Mysql client"
    

    mysql -h db.aws79s.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
    VALIDATE $? "Schema loading "

    systemctl restart backend &>>$LOGFILE
    VALIDATE $? "Restart backend "




    

