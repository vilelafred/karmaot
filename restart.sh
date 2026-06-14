#!/bin/bash

# Config
servername="karma"
sqlpassword="cM5a@U3hG4#hG2eX9"
# Allow core dumps
ulimit -c unlimited
export LC_ALL="C" #hack to work with utf-8
# Set working directory
cd /home/nekiro/

# Main loop
while true;
do

        date=`date "+%d-%m-%y-%H-%M-%S"`
        filename="${servername}-${date}"
        databasefile="backup.sql"
        logfile="${filename}.log"

		echo "Apagando logs antigos..."
		# Apagar arquivos com mais de 15 dias
		for i in `find logs/ -mtime +15`
			do
			rm -f $i
		done

		echo "Apagando backups antigos..."
		# Apagar arquivos com mais de 80 dias
		for i in `find database/ -mtime +80`
			do
			rm -f $i
		done
		
		
        gdb --command=/home/nekiro/ --args ./tfs | tee logs/$logfile
	echo "Waiting 5 seconds... If you want to close your server, do it now. (Ctrl+C)"
	sleep 5

	echo "Taking database backup..."
        mysqldump -uroot -p$sqlpassword s1 > $databasefile
        # rm -R backup.sql.gz
        # gzip $databasefile
        echo "Updating git"
	bash ./sync-git.sh
done;
