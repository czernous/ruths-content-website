#!/bin/bash
#cd "$(dirname "${BASH_SOURCE[0]}")/../../" || exit

if [ -f .env ]; then
    # Load Environment Variables
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    # For instance, will be example_kaggle_key
fi


CONTAINER_BACKUP_FOLDER=backup/
RESTORE_FOLDER=data/admin-db/backup
if [ -n "$1" ]; then
	BACKUP_FILE=$1
else
  BACKUP_LIST=($RESTORE_FOLDER/*)
  if [ ${#BACKUP_LIST[@]} -ne 0 ]; then
    echo 'Choose the backup file:'
    for i in "${!BACKUP_LIST[@]}"; do
      echo "$((++i)). ${BACKUP_LIST[((--i))]##*/}"
    done
    read -p 'Type the number of file: ' -e BACKUP_FILE_NUMBER
    BACKUP_FILE=${BACKUP_LIST[((--BACKUP_FILE_NUMBER))]}
  fi
fi

if [ ! -f "$BACKUP_FILE" ]; then
  echo "File does not exist" && exit
fi;

echo "The ${BACKUP_FILE##*/} is chosen"

IFS='/' read -ra backupArray <<< "$BACKUP_FILE"

backupName=${backupArray[${#backupArray[@]}-1]}
if [[ ${backupName} =~ "structure_" ]]; then
  backupName=${backupName##structure_}
  BACKUP_FILE="$RESTORE_FOLDER/${backupName}"
fi;
echo $CONTAINER_BACKUP_FOLDER$backupName

echo "Start database recovery"
docker exec -it admin-db bash -c "psql -f $CONTAINER_BACKUP_FOLDER$backupName -U $DATABASE_USER $DATABASE_NAME"

if [[ "${REMOVE_BACKUP}" = "Y" ]]; then
	rm -f "${BACKUP_FILE}"
fi;

echo "Database recovery is done";