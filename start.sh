#!/bin/bash

echo "🔄 Iniciando o servidor automático..."

cd /home/nekiro || exit 1

mkdir -p logs
mkdir -p database

# Configurações MySQL
usersql="root"
sqlpassword="P9954t%#1Ui6UC"
servername="karma"

ulimit -c unlimited
set -o pipefail

while true
do
    TIMESTAMP=$(date +"%F-%H-%M-%S")
    LOGFILE="logs/${TIMESTAMP}.log"
    DATABASEFILE="database/${servername}-$(date +"%d-%m-%Y-%H-%M-%S").sql"

    echo "🟢 [$TIMESTAMP] Iniciando TFS com GDB..." | tee -a "$LOGFILE"

    gdb --batch -return-child-result --command=antirollback_config --args ./tfs 2>&1 \
        | awk '{ print strftime("%F %T - "), $0; fflush(); }' \
        | tee -a "$LOGFILE"

    echo "📦 [$TIMESTAMP] Fazendo backup da database..." | tee -a "$LOGFILE"

mysqldump --no-tablespaces --databases karma | gzip > logs/backup_2025-09-06_14-41-08.sql.gz
        --extended-insert --quick --compress "$servername" > "$DATABASEFILE"

    if [ $? -eq 0 ]; then
        echo "✅ Backup salvo com sucesso em $DATABASEFILE" | tee -a "$LOGFILE"
        echo "⏳ Servidor finalizado normalmente. Aguardando 3 minutos..." | tee -a "$LOGFILE"
        sleep 15
    else
        echo "❌ Erro ao salvar backup da database!" | tee -a "$LOGFILE"
        echo "💥 Crash detectado. Reiniciando em 5 segundos..." | tee -a "$LOGFILE"
        sleep 5
    fi
done
