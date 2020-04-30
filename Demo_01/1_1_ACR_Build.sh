# DEMO 1 - Building custom MSSQL-Tools image with ACR
#
#   1- Create Azure Container Registry
#   2- Check ACR properties
#   3- Inspect Dockerfile - custom local image
#   4- Build local image - mssqltools
#   5- Tag and push local image to ACR repository
#   6- Check ACR repositories + images with VS Code Docker extension
#   7- Build and push image with Azure Cloud shell (single instruction)
#   8- List images in ACR repository
# -----------------------------------------------------------------------------
# References:
#   Azure Container Registry authentication with service principals
#   open https://docs.microsoft.com/en-us/azure/container-registry/container-registry-auth-service-principal
#   open https://docs.microsoft.com/en-us/azure/container-registry/container-registry-authentication
#
#   Azure CLI - ACR commands reference
#   open https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest

# 0- Env variables | demo path
resource_group=PASS-Marathon;
acr_name=dbamastery;
acr_repo=mssqltools-alpine;
cd ~/Documents/$resource_group/Demo_01;
az acr login --name $acr_name;

# 1- Create Azure Container Registry
az acr create --resource-group $resource_group --name $acr_name --sku Standard --location westus

# 2- List ACR registry
az acr list --resource-group $resource_group -o table

# 3- Inspect Dockerfile
# Custom mssqltools image with Alpine
code Dockerfile

# 4- Build local image - mssqltools
docker build . -t mssqltools-alpine -f Dockerfile

# 5- Tag and push local image to ACR repository
# Listing local image
docker images mssqltools-alpine

# Getting image id
image_id=`docker images | grep mssqltools-alpine | awk '{ print $3 }' | head -1`

# Tagging image with private registry and build number
# ACR FQN = dbamastery.azurecr.io/mssqltools-alpine:2.0
docker tag $image_id $acr_name.azurecr.io/$acr_repo:2.0
docker images

# Pushing image to ACR (dbamastery) - mssqltools-alpine repository
# Make sure to check ACR authentication and login process with Docker first
docker push $acr_name.azurecr.io/$acr_repo:2.0

# --------------------------------------
# Visual Studio Code extension - step
# --------------------------------------
# 6- Check ACR repositories + images with VS Code Docker extension 👀

# 7- Build and push image with Azure Cloud shell (single instruction)
# No Docker, no problem 👍👌

# Navigate to Azure portal and start a new Azure Cloud shell session
open https://portal.azure.com

# Navigate to cloud share
cd clouddrive/PASS-Marathon/Demo_01
ls -ll

# Build, tag and push in a single instruction
az acr build --image mssqltools-alpine:2.1 --registry dbamastery .

# 8- List images in ACR repository
az acr repository show --name $acr_name --repository $acr_repo -o table
az acr repository show-manifests --name $acr_name --repository $acr_repo
az acr repository show-tags --name $acr_name --repository $acr_repo --detail
az acr task logs --registry $acr_name