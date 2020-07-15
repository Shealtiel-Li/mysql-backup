#!/bin/bash

BACKUP_DIR=$1
BIN_FILE=$BINLOG_FILE

mkdir -p $BACKUP_DIR

docker exec $CONTAINER_NAME $ADMIN_PATH -u$USER -p"$PASSWORD" flush-logs

Counter=`wc -l $BIN_FILE | awk '{print $1}'`

NextNum=0

for file in `cat $BIN_FILE`
do
    base=`basename $file`
    echo $base
    NextNum=`expr $NextNum + 1`
    if [ $NextNum -eq $Counter ]
    then
        echo $base skip!
    else
        dest=$BACKUP_DIR/$base
        if(test -e $dest)
        then
            echo $base exist!
        else
            cp $DIR/$base $BACKUP_DIR
            echo $base copying
         fi
     fi
done

