#!/bin/bash

path="/home/nekiro/database"					#Path where the backup of your database "Db
nameBackup="karma772"					#Name of your choice for the backup
mysqlUser="root"					#Your MySQL user
mysqlPass="P9954t%#1Ui6UC"					#Your MySQL password
mysqlDatabase="karma"				#The name of your database "Db


# Don't move from here
TIMER="$(date +'%d-%m-%Y-%H-%M')"

if [[ -z "$mysqlUser" || -z "$mysqlPass" || -z "$mysqlDatabase" ]]; then
    echo "Please fill in username, password and database in settings."
else
    mysqldump -u$mysqlUser -p$mysqlPass $mysqlDatabase > $path"/"$nameBackup"-"$TIMER".sql"
    echo "Backup Complete."
fi
