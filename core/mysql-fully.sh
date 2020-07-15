#!/bin/bash
BACKUP_DIR=$1

mkdir -p $BACKUP_DIR

Date=`date +%Y%m%d`

cd $BACKUP_DIR

DumpFile=$Date.sql

GZDumpFile=$Date.sql.tgz

docker exec -i $CONTAINER_NAME $DUMP_PATH -u$USER -p"$PASSWORD" $DATABASE --single-transaction > $DumpFile

tar -zvcf $GZDumpFile $DumpFile

rm $DumpFile

# 重置增量备份日志
if [ $RESET_MASTRE ]; then
  docker exec  $CONTAINER_NAME mysql -u$USER -p"$PASSWORD" -e "reset master;"
fi

