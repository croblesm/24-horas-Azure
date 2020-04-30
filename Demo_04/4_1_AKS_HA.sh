# DEMO 4 - SQL Server HA in AKS
#   1- Connect to Kubernetes cluster in AKS
#   2- Get namespaces, nodes, pods and more
#   3- Check PVC and azure disks provisioned on Kubernetes RG
#   4- Check pod events
#   5- Check pod logs
#   6- Get public IP of SQL Server service
#   7- Connect with Azure Data Studio (Azure Data Studio - Optional)
#   8- Connect to SQL Server to create new database
#   9- Simulate failure
#   10- Get SQL Server instance properties (Azure Data Studio - Optional)
#   11- Explore database objects (Azure Data Studio - Optional)
#   12- Show Kubernetes dashboard
# -----------------------------------------------------------------------------
# References:
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Azure CLI - Kubernetes
#   https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

# 0- Environment variables | demo path
resource_group=PASS-Marathon;
aks_cluster=endurance;
namespace_simple=plex-sql;
namespace_complex=tars-sql;
acr_name=dbamastery;
sa_password="_EnDur@nc3_";
cd ~/Documents/$resource_group/Demo_04;

# 1- Connect to Kubernetes cluster in AKS
az aks get-credentials --resource-group $resource_group --name $aks_cluster
kubectl config set-context $aks_cluster
kubectl config set-context --current --namespace=$namespace_simple
kubectl config get-contexts

# 2- Get namespaces, nodes, pods and more
kubectl get namespaces
kubectl get nodes
kubectl get pods --all-namespaces
kubectl get services --all-namespaces
kubectl get all --all-namespaces

# 3- Check PVC and azure disks provisioned on Kubernetes RG
kubectl describe pvc pvc-data-plex
kubectl describe pvc pvc-data-plex | grep "Volume:"

# List disks assigned to Kubernetes RG
az disk list --resource-group MC_PASS-Marathon_endurance_westus --query '[].{Name:name, Size:diskSizeGb, DiskState:diskState}' -o table

# Filtering by individual disk
az_disk=`kubectl describe pvc pvc-data-plex | grep "Volume:" | awk '{print $2}'`
az disk list --resource-group MC_PASS-Marathon_endurance_westus --query "[?name=='kubernetes-dynamic-$az_disk'].{Name:name, Size:diskSizeGb, DiskState:diskState}" --output table
# Go to the portal --> All resources --> Look for PVC disk

# 4- Check pod events
MyPod=`kubectl get pods | grep mssql-plex | awk {'print $1'}`
kubectl describe pods $MyPod

# 5- Check pod logs
kubectl logs $MyPod -f

# 6- Get public IP of SQL Server service
kubectl get service mssql-plex-service
MyService=`kubectl get service mssql-plex-service | grep mssql-plex | awk {'print $4'}`

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 7- Connect with Azure Data Studio
cd ~
open  /Applications/Azure\ Data\ Studio.app 

# 8- Connect to SQL Server to create new database
sqlcmd -S $MyService,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $MyService,1400 -U SA -P $sa_password -Q "set nocount on; select @@version;"
sqlcmd -S $MyService,1400 -U SA -P $sa_password -i "4_2_CreateDatabase.sql"
sqlcmd -S $MyService,1400 -U SA -P $sa_password -Q "set nocount on; select name from sys.databases;"

# 9- Simulate failure
cd ~/Documents/$resource_group/Demo_04
./4_3_SimulateFailure.sh

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 10- Get SQL Server instance properties
# 11- Explore database objects

# 12- Show Kubernetes dashboard
az aks browse --resource-group $resource_group --name $aks_cluster