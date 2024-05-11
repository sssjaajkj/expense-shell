#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
 SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
 LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

R="\e[31m"
G="\e[32m"
y="\e[33m"
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

    dnf install mysql-server -y &>>LOGFILE
    VALIDATE $? "Installing MYSQL Server"

    systemctl enable mysqld  &>>LOGFILE
     VALIDATE $? "Enable  MYSQL Server"

    systemctl start mysqld &>>LOGFILE
    VALIDATE $? "start  MYSQL Server"

#     mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
#     VALIDATE $? "Setting up root password"   

        #Below code will be useful for idempotemt nature
        mysql -h db.aws79s.online -uroot -pExpenseApp@11 -e 'SHOW DATABASES;' &>>$LOGFILE

        if [$? -ne 0 ]
        then

         mysql_secure_installation --set-root-pass ExpenseApp@1 
        VALIDATE $? "MySQL Root password Setup"
        else
         echo -e "Mysql root password is already setup --- $Y Skipping $N"
         fi
         