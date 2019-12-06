export GROUP='poc'
export DATABASE_ACCOUNT='cosmosaccount-mongo-$GROUP'

az cosmosdb delete --resource-group $GROUP --name $DATABASE_ACCOUNT

