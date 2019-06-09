Param(
    [parameter(Mandatory = $false)]
    [string]$resourceGroupName = "twitterliverg",
    [parameter(Mandatory = $false)]
    [string]$clusterName = "twitterliveAKSCluster"
)

# Browse AKS dashboard
Write-Host "Browse AKS cluster $clusterName" -ForegroundColor Yellow
az aks browse `
    --resource-group=$resourceGroupName `
    --name=$clusterName