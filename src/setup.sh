resourceGroupName="arm-test"
suffix="fs20200716"
location="eastus"
##Storage Account Settings#############################################
storageAccountName="storageaccount${suffix}"
storageAccountAccessTier="cool"
storageAccountPublicAccess="true"
storageAccountByPass="AzureServices"
storageAccountDefaultAction="Allow"
##Hierarchical Namespace (true for data lake)
storageAccountHN="true"
storageAccountHttps="true"
storageAccountKind="StorageV2"
storageAccountSKU="Standard_LRS"

##SQL Server Settings##################################################
sqlServerAdmin="sql_admin"
sqlServerPW="Tutorial_Password1"
sqlServerName="sqlserver${suffix}"
sqlServerPublicNetwork="true"

##SQL DB Settings######################################################
sqldbName="sqldb${suffix}"
sqldbTier="Basic"
sqldbMax="2GB"
sqldbMin="1"
sqldbFamily="Gen5"
sqldbCapacity="1"

##Key Vault Settings###################################################
kvName="kv${suffix}"
kvByPass="AzureServices"
kvDefaultAction="Allow"
kvSKU="standard"
kvSoftDelete="false"
kvsqldbpwName="sqldbpw"
kvstoragkeyName="storagekey"

echo "You need to login"
az login

az storage account create --name $storageAccountName \
	--resource-group $resourceGroupName \
	--access-tier $storageAccountAccessTier \
	--allow-blob-public-access $storageAccountPublicAccess \
	--bypass $storageAccountByPass \
	--default-action $storageAccountDefaultAction \
	--https-only $storageAccountHttps \
	--kind $storageAccountKind \
	--enable-hierarchical-namespace $storageAccountHN \
 	--sku $storageAccountSKU \
	--location $location

az sql server create --admin-password $sqlServerPW \
	--admin-user $sqlServerAdmin \
	--name $sqlServerName \
	--resource-group $resourceGroupName \
	--enable-public-network $sqlServerPublicNetwork \
	--location $location

sleep 20s

az sql db create --name $sqldbName \
	--resource-group $resourceGroupName \
	--server $sqlServerName \
	--family $sqldbFamily \
	--capacity $sqldbCapacity \
	--max-size $sqldbMax \
	--min-capacity $sqldbMin \
	--tier $sqldbTier

az keyvault create --name $kvName \
	--resource-group $resourceGroupName \
	--bypass $kvByPass \
	--default-action $kvDefaultAction \
	--sku $kvSKU \
	--location $location \
	--enable-soft-delete $kvSoftDelete


az sql server firewall-rule create --resource-group $resourceGroupName \
	--name azureservices \
	--server $sqlServerName \
	--start-ip-address 0.0.0.0 \
	--end-ip-address 0.0.0.0

az keyvault secret set --name $kvsqldbpwName \
	--vault-name $kvName
	--value $sqlServerPW
