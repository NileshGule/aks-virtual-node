Param(
    [parameter(Mandatory = $false)]
    [string]$subscriptionName = "Microsoft Azure Sponsorship",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "twitterliverg",
    [parameter(Mandatory = $false)]
    [string]$resourceGroupLocaltion = "South East Asia",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "twitterliveAKSCluster",
    [parameter(Mandatory = $false)]
    [string]$dnsNamePrefix = "twitterlivedns",
    [parameter(Mandatory = $false)]
    [int16]$workerNodeCount = 2,
    [parameter(Mandatory = $false)]
    [string]$kubernetesVersion = "1.13.5"

)

# Set Azure subscription name
Write-Host "Setting Azure subscription to $subscriptionName"  -ForegroundColor Yellow
az account set --subscription=$subscriptionName

# Create resource group name
Write-Host "Creating resource group $resourceGroupName in region $resourceGroupLocaltion" -ForegroundColor Yellow
az group create `
    --name=$resourceGroupName `
    --location=$resourceGroupLocaltion `
    --output=jsonc

#Create virtual network
$twitterliveVnet = "twitterliveVnet"
$twitterliveAKSSubnet = "twitterliveAKSSubnet"
Write-Host "Creating vNet $twitterliveVnet and subnet $twitterliveAKSSubnet" -ForegroundColor Yellow
az network vnet create `
    --resource-group $resourceGroupName `
    --name $twitterliveVnet `
    --address-prefixes 10.0.0.0/8 `
    --subnet-name $twitterliveAKSSubnet `
    --subnet-prefix 10.240.0.0/16

#Create virtual node subnet
$twitterliveAKSVNodeSubnet = "twitterliveAKSVNodeSubnet"
Write-Host "Creating vNet $twitterliveVnet and subnet $twitterliveAKSSubnet" -ForegroundColor Yellow
az network vnet subnet create `
    --resource-group $resourceGroupName `
    --vnet-name $twitterliveVnet `
    --name twitterliveAKSVNodeSubnet `
    --address-prefixes 10.241.0.0/16

#Create service principal
Write-Host "Creating Service Principal" -ForegroundColor Yellow
az ad sp create-for-rbac --skip-assignment

# # $servicePrincipalAppId = $(az ad sp list --display-name $appId --query "[].appId" -o tsv)

# # Create AKS cluster
# Write-Host "Creating AKS cluster $clusterName with resource group $resourceGroupName in region $resourceGroupLocaltion" -ForegroundColor Yellow
# az aks create `
#     --resource-group=$resourceGroupName `
#     --name=$clusterName `
#     --node-count=$workerNodeCount `
#     --dns-name-prefix=$dnsNamePrefix `
#     --generate-ssh-keys `
#     --node-vm-size=Standard_D2_v2 `
#     --kubernetes-version=$kubernetesVersion `
#     --enable-addons http_application_routing

# # Get credentials for newly created cluster
# Write-Host "Getting credentials for cluster $clusterName" -ForegroundColor Yellow
# az aks get-credentials `
#     --resource-group=$resourceGroupName `
#     --name=$clusterName

# Write-Host "Successfully created cluster $clusterName with kubernetes version $kubernetesVersion and $workerNodeCount node(s)" -ForegroundColor Green

# Write-Host "Creating cluster role binding for Kubernetes dashboard" -ForegroundColor Green
# kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

# Write-Host "Creating Tiller service account for Helm" -ForegroundColor Green
# Set-Location ~/projects/AKS-Learning-Series/Helm/
# kubectl apply -f .\helm-rbac.yaml

# Write-Host "Initializing Helm with Tiller service account" -ForegroundColor Green
# helm init --service-account tiller

# Set-Location ~/projects/AKS-Learning-Series/Powershell