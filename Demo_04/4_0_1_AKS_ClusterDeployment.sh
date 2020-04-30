# DEMO 4 - Azure Kubernetes services (AKS) cluster Deployment
#   Kubernetes cluster creation in AKS
#
#   1- Create AKS cluster
#   2- Get AKS credentials for AKS cluster
#   3- Check kubectl cluster context
#   4- Get AKS cluster nodes
# -----------------------------------------------------------------------------
# References:
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Azure CLI - Kubernetes
#   https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest

# 0- Env variables | demo path
resource_group=PASS-Marathon;
aks_cluster=endurance
location=westus
acr_name=dbamastery;
az aks get-versions --location $location --output table;
k8s_version=1.16.7;
vm_size=Standard_DS3_v2;
cd ~/Documents/$resource_group/Demo_04;

# 1- Create AKS cluster
az aks create \
    --resource-group $resource_group \
    --location $location \
    --name $aks_cluster \
    --kubernetes-version $k8s_version \
    --node-count 2 \
    --node-vm-size $vm_size \
    --node-osdisk-size 100 \
    --vm-set-type AvailabilitySet \
    --dns-name-prefix $aks_cluster-dns \
    --load-balancer-sku standard \
    --generate-ssh-keys \
    --attach-acr $acr_name

# 2- Get AKS credentials for AKS cluster
az aks get-credentials --resource-group $resource_group --name $aks_cluster

# 3- Create cluster role for dashboard
kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# 3- Check kubectl cluster context
kubectl config get-contexts

# 4- Get AKS cluster nodes
kubectl get nodes