az group create --name poc --location "North Europe"

az cosmosdb create \
    --resource-group poc \
    --name cosmosaccount-mongo-poc \
    --kind MongoDB \
    --locations "North Europe"=0 "West Europe"=1 \
    --default-consistency-level "Session" \
    --enable-multiple-write-locations true
