export HOST=myadvisory-dev-cosmos.documents.azure.com
export USER=myadvisory-dev-cosmos
export PASS=62bh1kCnSv6ej3Q8bSat5tenTB42gUmd7sWSuthSirqCiGEzrglJPyU6MPwYBiq2NUFXzP7bRZQ4P6SlyaDrzA== 
export DB=myadvisory
export PORT=10255


export TMP_DIR='/tmp/mongodump'
export MONGO_VERSION='3.4'


# FIXME: gerer correctement le "user"
sudo rm -rf $TMP_DUMP && sudo mkdir $TMP_DUMP
sudo chmod +777 $TMP_DUMP



if [ -n "$1" ]; then
  echo "[ \"$1\" ]" > collections.json
  echo "##### Extract collection : $1"
else
   az cosmosdb mongodb collection list -g dev -a $USER -d $DB --query=[].mongoDbCollectionId > collections.json
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


   #  mongoexport --host=$HOST --port=$PORT --username=$USER --password=$PASS --db=$DB --ssl --collection=$ITEM --out=$ITEM.json >> $ITEM.log 2>&1


    docker run --rm \
       -v $TMP_DIR:/tmp \
       mongo:$MONGO_VERSION mongoexport \
         --host=$HOST --port=$PORT --username=$USER --password=$PASS --db=$DB \
         -vvvvv --ssl --collection=$ITEM --out=/tmp/$ITEM.json >> $ITEM.log 2>&1


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


# zippage
ls -R $TMP_DUMP/*
tar -cvf backup_$(date '+%d-%m-%Y_%H-%M-%S').gz $TMP_DUMP/* 