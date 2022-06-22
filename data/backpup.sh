#!/bin/bash
BACKUP_FOLDER="backup/"

DUMP_NAME="postgresql_dump_"
CURRENT_DATE=$(date +"%m_%d_%Y")

echo "${n}"

if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    # For instance, will be example_kaggle_key
    echo "Backing up $DATABASE_NAME database"
    docker exec -it admin-db bash -c "pg_dump --clean -U $DATABASE_USER $DATABASE_NAME -w $DATABASE_PASSWORD -f $BACKUP_FOLDER$DUMP_NAME$CURRENT_DATE.dmp $x"
    #sudo chmod -R 777 data/admin-db/backup
    echo "Backing up $DATABASE_NAME database completed"
fi