
export HOST=cosmosaccount-mongo-poc-ops.documents.azure.com
export USER=cosmosaccount-mongo-poc-ops
export USER_ORIGIN=myadvisory-dev-cosmos
export ENV_ORIGIN=dev
export PASS=HEZh8Fn50mwZbuwDrtCBdFO2cft4rs3Zl8HkK7lt4m8MV0GFIawXw3gK6WffVoEDDXUzGJTKjsaWUZEobIasrg== 
export DB=myadvisory
export PORT=10255


export TMP_DIR='/tmp/mongodump'
export MONGO_VERSION='latest'


# attention, on risque de manquer des tables
if [ -n "$1" ]; then
  echo "[ \"$1\" ]" > collections.json
  echo "##### Extract collection : $1"
else
   az cosmosdb mongodb collection list -g $ENV_ORIGIN -a $USER_ORIGIN -d $DB --query=[].mongoDbCollectionId > collections.json
   echo "##### Extract collection(s) form azure CLI"
fi

cat collections.json
rm *.log


# Itération
for row in $(cat collections.json | jq '.[]'); do
    _jq() {
      echo ${row} | jq -r ${1}
    }
    ITEM=$(_jq  '.')

    echo "##############################################"
    echo "##### Exporting collection :  $ITEM"


# mongoimport --host=$HOST --port=$PORT --username=$USER --password=$PASS --db=$DB --drop --ssl --collection=translations --file=/tmp/translations.json

    # ATTENTION JE DROP L'EXISTANT
    docker run --rm \
       -v $TMP_DIR:/tmp \
       mongo:$MONGO_VERSION mongoimport \
         --host=$HOST --port=$PORT --username=$USER --password=$PASS --db=$DB \
         --drop -vv --ssl --stopOnError --batchSize=10 \
         --collection=$ITEM --file=/tmp/$ITEM.json >> $ITEM.log 2>&1


    if `grep -q "error" $ITEM.log` ;
        then
            echo "##### > Failure"
        else
            echo "##### > Succes"
        fi

done

echo 'DONE !'

echo "##### Failed import(s) : ####"
grep --include=\*.log -rnw './' -e "error"
echo "##### Ended ! #####"


echo "detecter pattern 'error Error failure ....' "

