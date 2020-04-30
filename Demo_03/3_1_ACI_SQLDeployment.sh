# DEMO 3 - Script deployment for SQL containers in ACI 
#
#   1- Check SQL container status
#   2- Connect to ACI bash console to explore folders
#   3- Listing folders and files
#   4- Explore ACI + Azure file share with Azure Storage Explorer
#   5- Copy SQL scripts to file share (Azure Storage Explorer)
#   6- Deploy SQL script (From container)
#   7- Get SQL Server instance properties (Azure Data Studio)
#   8- Explore database objects (Azure Data Studio - Optional)
# -----------------------------------------------------------------------------
# References:
#   Mount an Azure file share in Azure Container Instances
#   open https://docs.microsoft.com/en-us/azure/container-instances/container-instances-volume-azure-files

# 0- Env variables | demo path
resource_group=PASS-Marathon
storage_account_name=acivolumes
location=westus
file_share_name=aci-fileshare
aci_name=aci-sql-dev02;
cd ~/Documents/$resource_group/Demo_03;
 
# 1- Check SQL container status
az container show \
    --resource-group $resource_group \
    --name $aci_name \
    --query "{Status:instanceView.state}" -o table

# 2- Connect to ACI bash console to explore folders
az container exec --resource-group $resource_group --name $aci_name --exec-command "/bin/bash"

# 3- Listing folders and files

# Creating temp bash profile
## Saving bash prompt changes into temp bash profile
# echo "export PS1=\"[dba mastery@ACI] $ \"" > /tmp/sql/.bashrc
## Saving SA password env variable into temp bash profile
# echo "export SQLCMDPASSWORD=_SqLr0ck5_" >> /tmp/sql/.bashrc
## Exporting mssql-tools path
# echo "export PATH=\$PATH:/opt/mssql-tools/bin" >> /tmp/sql/.bashrc

# Loading profile settings
source /tmp/sql/.bashrc

# Check folders and files
ls -ll /SQLFiles/SQLScripts

# --------------------------------------
# Azure Storage Explorer step
# --------------------------------------
# 4- Explore ACI + Azure file share with Azure Storage Explorer
# 5- Copy SQL scripts to file share

# 6- Deploy SQL script (from container)
sqlcmd -U SA -d master -i /SQLFiles/SQLScripts/3_2_Create_Database.sql

# Checking deployment results (from container)
sqlcmd -U SA -d master -Q "set nocount on; select name from sys.databases"

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 7- Get SQL Server instance properties
# 8- Explore database objects