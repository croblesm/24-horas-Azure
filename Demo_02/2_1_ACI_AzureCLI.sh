# DEMO 2 - ACI Container (Azure CLI)
# Part 1 - Azure CLI experience
#
#   1- Create SQL container in ACI
#   2- Check SQL Container logs
#   3- Check SQL Container properties
#   4- Connect to SQL Server container in ACI (Azure Data Studio)
#   5- Show SQL instance dashboard (Azure Data Studio - Optional)
#   6- Basic container lifecycle management (Optional)
#       # Stop, start, delete
# -----------------------------------------------------------------------------
# References:
#   Query Azure CLI command output
#   open https://docs.microsoft.com/en-us/cli/azure/query-azure-cli?view=azure-cli-latest
#
#   Azure CLI - ACR commands reference
#   open https://docs.microsoft.com/en-us/cli/azure/acr?view=azure-cli-latest

# 0- Env variables | demo path
resource_group=PASS-Marathon;
aci_name=aci-sql-dev01;
cd ~/Documents/$resource_group/Demo_02;

# 1- Create SQL Server container in ACI
az container create \
    --resource-group $resource_group \
    --name $aci_name \
    --image mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04 \
    --environment-variables ACCEPT_EULA=Y SA_PASSWORD=_SqLr0ck5_ \
    --dns-name-label $aci_name \
    --cpu 4  --memory 4 \
    --port 1433

{
  "containers": [
    {
      "command": null,
      "environmentVariables": [
        {
          "name": "ACCEPT_EULA",
          "secureValue": null,
          "value": "Y"
        },
        {
          "name": "SA_PASSWORD",
          "secureValue": null,
          "value": "_SqLr0ck5_"
        }
      ],
      "image": "mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04",
      "instanceView": {
        "currentState": {
          "detailStatus": "",
          "exitCode": null,
          "finishTime": null,
          "startTime": "2020-04-09T18:17:41+00:00",
          "state": "Running"
        },
        "events": [
          {
            "count": 1,
            "firstTimestamp": "2020-04-09T18:16:24+00:00",
            "lastTimestamp": "2020-04-09T18:16:24+00:00",
            "message": "pulling image \"mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04\"",
            "name": "Pulling",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2020-04-09T18:17:35+00:00",
            "lastTimestamp": "2020-04-09T18:17:35+00:00",
            "message": "Successfully pulled image \"mcr.microsoft.com/mssql/server:2019-CU4-ubuntu-18.04\"",
            "name": "Pulled",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2020-04-09T18:17:41+00:00",
            "lastTimestamp": "2020-04-09T18:17:41+00:00",
            "message": "Created container",
            "name": "Created",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2020-04-09T18:17:41+00:00",
            "lastTimestamp": "2020-04-09T18:17:41+00:00",
            "message": "Started container",
            "name": "Started",
            "type": "Normal"
          }
        ],
        "previousState": null,
        "restartCount": 0
      },
      "livenessProbe": null,
      "name": "aci-sql-dev01",
      "ports": [
        {
          "port": 1433,
          "protocol": "TCP"
        }
      ],
      "readinessProbe": null,
      "resources": {
        "limits": null,
        "requests": {
          "cpu": 4.0,
          "gpu": null,
          "memoryInGb": 4.0
        }
      },
      "volumeMounts": null
    }
  ],
  "diagnostics": null,
  "dnsConfig": null,
  "id": "/subscriptions/a3729944-2d39-4be1-8251-0529dd60c431/resourceGroups/PASS-Marathon/providers/Microsoft.ContainerInstance/containerGroups/aci-sql-dev01",
  "identity": null,
  "imageRegistryCredentials": null,
  "instanceView": {
    "events": [],
    "state": "Running"
  },
  "ipAddress": {
    "dnsNameLabel": "aci-sql-dev01",
    "fqdn": "aci-sql-dev01.westus.azurecontainer.io",
    "ip": "13.88.140.96",
    "ports": [
      {
        "port": 1433,
        "protocol": "TCP"
      }
    ],
    "type": "Public"
  },
  "location": "westus",
  "name": "aci-sql-dev01",
  "networkProfile": null,
  "osType": "Linux",
  "provisioningState": "Succeeded",
  "resourceGroup": "PASS-Marathon",
  "restartPolicy": "Always",
  "tags": {},
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": null
}

# 2- Check SQL Container logs
az container logs  --resource-group $resource_group --name $aci_name --follow

# 3- Check SQL Container properties
# Listing all containers in my ACI group
az container list --resource-group $resource_group -o table

# Listing specific container properties
az container show \
    --resource-group $resource_group \
    --name $aci_name

az container show \
    --resource-group $resource_group \
    --name $aci_name \
    --query "{IP_Adress:ipAddress.ip, FQDN:ipAddress.fqdn}" --out table

az container list \
    --resource-group $resource_group \
    --query "sort_by([].{Name:name,FQDN:ipAddress.fqdn,IP:ipAddress.ip,Port:ipAddress.ports[].port,Status:provisioningState}, &Name)" -o json

# --------------------------------------
# Azure Data Studio step
# --------------------------------------
# 4- Connect to SQL Server container in ACI
# 5- Show SQL instance dashboard

# 6- Basic container lifecycle management (Optional)
# Stop container
az container stop --name $aci_name --resource-group $resource_group

# Start container
az container start --name $aci_name --resource-group $resource_group

# Delete container
az container delete --name $aci_name --resource-group $resource_group