# DEMO 2 - Managing a SQL container (Portal experience)
# Part 2 - Azure Portal experience
#
#   1- Open Azure portal and navigate to resource group / ACI
#   2- Monitor CPU and memory utilization
#   3- Check container logs
#   4- Connect to container console
#   5- Stop container 
#   6- Start container
#   7- Delete container
# -----------------------------------------------------------------------------
# References:
#   Azure Container Instances (overview)
#   open https://azure.microsoft.com/en-us/services/container-instances/#overview

# 0- Env variables | demo path
resource_group=PASS-Marathon;
aci_name=aci-sql-dev01;
cd ~/Documents/$resource_group/Demo_02;

# 1- Open Azure portal and navigate to resource group / ACI
open https://portal.azure.com/#home

# 2- Monitor CPU and memory utilization
Go to Resource group --> aci-sql-dev-01 --> Overview

# 3- Check container logs
Go to Resource group --> aci-sql-dev-01 --> Containers --> Logs
# Azure CLI reference
az container logs  --resource-group $resource_group --name $aci_name --follow

# 4- Connect to container console
Go to Resource group --> aci-sql-dev-01 --> Containers --> Connect --> Choose "/bin/bash"
# Azure CLI reference
az container exec --resource-group $resource_group --name $aci_name --exec-command "/bin/bash"

# 5- Stop container
Go to Resource group --> aci-sql-dev-01 --> Overview --> Stop
# Azure CLI reference
az container stop --name $aci_name --resource-group $resource_group

# 6- Start container
Go to Resource group --> aci-sql-dev-01 --> Overview --> Start
# Azure CLI reference
az container start --name $aci_name --resource-group $resource_group

# 7- Delete container
Go to Resource group --> aci-sql-dev-01 --> Overview --> Delete
# Azure CLI reference
az container delete --name $aci_name --resource-group $resource_group