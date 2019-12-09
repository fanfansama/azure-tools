source ./setEnv.sh

export TMP_DIR='/tmp/mongodump'


if [ -n "$1" ]; then
  echo "[ \"$1\" ]" > collections.json
  echo "##### Extract collection : $1"
else
   az cosmosdb mongodb collection list -g dev -a myadvisory-dev-cosmos -d myadvisory --query=[].mongoDbCollectionId > collections.json
   echo "##### Extract collection(s) form azure CLI"
fi

cat collections.json
rm *.log

for row in $(cat collections.json | jq '.[]'); do
    _jq() {
      echo ${row} | jq -r ${1}
    }
    ITEM=$(_jq  '.')

    echo "##############################################"
    echo "##### restoring collection :  $ITEM"

    docker run --rm \
       -v $TMP_DIR:/tmp \
       mongo mongorestore --drop -vvvv \
        --maintainInsertionOrder \
        --numParallelCollections=1 \
        --numInsertionWorkersPerCollection=1 \
        --noIndexRestore \
        --nsInclude=myadvisory.$ITEM \
        --dir=/tmp/dump \
        --uri=$DB_TARGET_CONNECT_STRING >> $ITEM.log 2>&1


      if `grep -q "Failed" $ITEM.log` ;
        then
                echo "##### > Failure"
        else
                echo "##### > Succes"
        fi

done

echo 'DONE !'

echo "##### Failed import(s) : ####"
grep --include=\*.log -rnw './' -e "Failed"
echo "##### Ended ! #####"


echo "detecter pattern 'error' "
