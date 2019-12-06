export GROUP='poc'
export DATABASE_ACCOUNT='cosmosaccount-mongo-'$GROUP
export REGION='North Europe'
export REGION2='West Europe'

echo "create group : $GROUP"

az group create --name $GROUP --location "$REGION"

echo "create database : $DATABASE_ACCOUNT" 

az cosmosdb create \
    --resource-group $GROUP \
    --name $DATABASE_ACCOUNT \
    --kind MongoDB \
    --locations "$REGION"=0 "$REGION2"=1 \
    --default-consistency-level "Session" \
    --enable-multiple-write-locations false \
    --capabilities "EnableAggregationPipeline" "MongoDBv3.4" \
    --enable-automatic-failover false
