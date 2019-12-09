export GROUP='poc'
export DATABASE_ACCOUNT='bonds'
export ACCOUNT='cosmosaccount-mongo-'$GROUP

# Arguments
#    --account-name -a   [Required] : Cosmosdb account name.
#    --name -n           [Required] : Database name.
#    --resource-group -g [Required] : Name of resource group. You can configure the default group
#                                     using `az configure --defaults group=<name>`.


increaseRU=1000


originalRU=$(az cosmosdb mongodb database throughput show \
    -g $GROUP -a $ACCOUNT -n $DATABASE_ACCOUNT \
    --query throughput -o tsv)

echo $originalRU
newRU=$((originalRU + increaseRU))

az cosmosdb mongodb database throughput update \
    -a $ACCOUNT \
    -g $GROUP \
    -n $DATABASE_ACCOUNT \
    --throughput $newRU
