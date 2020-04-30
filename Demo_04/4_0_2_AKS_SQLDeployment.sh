# DEMO 4 - SQL Server - AKS deployment
#   SQL Server deployment in AKS
#
#   1- Create namespace, secret, pvc, service and SQL Server
#   2- Check namespace, secret, pvc, service and pod
#   3- Check pod logs
#   4- Get service IP
#   5- Test connectivity through queries
# -----------------------------------------------------------------------------
# References:
#   Kubernetes cheat sheet
#   https://kubernetes.io/docs/reference/kubectl/cheatsheet/
#
#   Deploy a SQL Server container in Kubernetes with Azure Kubernetes Services (AKS)
#   https://docs.microsoft.com/en-us/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15

# 0- Env variables | demo path
resource_group=PASS-Marathon;
cd ~/Documents/$resource_group/Demo_04;
sa_password="_EnDur@nc3_";

# 1- Create namespace, secret, pvc, service and SQL Server
kubectl create namespace plex-sql
kubectl config set-context --current --namespace=plex-sql
kubectl config get-contexts
kubectl create secret generic plex-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-plex.yaml
kubectl apply -f ./services/srvc-sql-plex.yaml
kubectl apply -f ./deployments/depl-sql-plex.yaml --record

# 2- Check namespace, secret, pvc, service and pod
kubectl get pvc --namespace=plex-sql
kubectl get services --namespace=plex-sql
kubectl get pods --namespace=plex-sql
pod=`kubectl get pods | grep mssql-plex-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

# 4- Get service IP
kubectl get service mssql-plex-service
plex_service=`kubectl get service mssql-plex-service | grep mssql-plex | awk {'print $4'}`

# 5- Test connectivity through queries
sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $plex_service,1400 -U SA -P $sa_password -Q "set nocount on; select @@version;"

# 1- Create namespace, secret, pvc, service and SQL Server
kubectl create namespace tars-sql
kubectl config set-context --current --namespace=tars-sql
kubectl create secret generic tars-cred --from-literal=SA_PASSWORD="_EnDur@nc3_"
kubectl apply -f ./persistent-volumes/pvc-data-tars.yaml
kubectl apply -f ./services/srvc-sql-tars.yaml
kubectl apply -f ./deployments/depl-sql-tars.yaml --record

# 2- Check namespace, secret, pvc, service and pod
kubectl get pvc --namespace=tars-sql
kubectl get services --namespace=tars-sql
kubectl get pods --namespace=tars-sql
pod=`kubectl get pods | grep mssql-tars-deployment | awk {'print $1'}`
kubectl describe pods $pod

# 3- Check pod logs
kubectl logs $pod -f

# 4- Get service IP
kubectl get service mssql-tars-service --watch
tars_service=`kubectl get service mssql-tars-service | grep mssql-tars | awk {'print $4'}`

# 5- Test connectivity through queries
sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@servername;"
sqlcmd -S $tars_service,1401 -U SA -P $sa_password -Q "set nocount on; select @@version;"