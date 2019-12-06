source ./setEnv.sh

export TMP_DUMP='/tmp/mongodump'

rm -rf $TMP_DUMP && mkdir $TMP_DUMP
chmod +777 $TMP_DUMP

docker run --rm \
    -v /tmp/mongodump:/tmp \
    mongo mongodump \
    --out=/tmp/dump \
    --uri=$DB_ORIGIN_CONNECT_STRING

sudo chmod -R +777 $TMP_DUMP

ls -R $TMP_DUMP/*

tar -cvf backup_$(date '+%d-%m-%Y_%H-%M-%S').gz $TMP_DUMP/* 
