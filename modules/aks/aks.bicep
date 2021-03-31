// params

@description('The name of the Managed Cluster resource.')
param clusterName string = 'aks101'

@description('The subnet to use for the AKS')
param subnetRef string

@description('The DNS prefix to use with hosted Kubernetes API server FQDN.')
param dnsPrefix string = 'cl01'

@description('Specifies the Azure location where the key vault should be created.')
param location string = resourceGroup().location

@minValue(1)
@maxValue(50)
@description('The number of nodes for the cluster.')
param agentCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_D2_v3'

@description('OS Disk Size in GB to be used to specify the disk size for every machine. 0 is for vmsize default')
param osDiskSizeGB int = 0

@allowed([
  'Paid'
  'Free'
])
@description('The AKS tier')
param aksTier string = 'Free'

@description('Whether to enable auto-scale')
param enableAutoScaling bool = false

@description('Specifies the Azure tags that will be assigned to the resource.')
param tags object = {
  environment: 'test'
}

@description('Specifies the Azure tags that will be assigned to the resource.')
param kubernetesVersion string = '1.19.7'

var nodeResourceGroup = 'rg-${dnsPrefix}-${clusterName}'

var agentPoolName = 'agentpool01'

// Azure kubernetes service
resource aks 'Microsoft.ContainerService/managedClusters@2021-02-01' = {
  name: clusterName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: kubernetesVersion
    enableRBAC: true
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: agentPoolName
        count: agentCount
        mode: 'System'
        vmSize: agentVMSize
        type: 'VirtualMachineScaleSets'
        osType: 'Linux'
        osDiskSizeGB: osDiskSizeGB
        enableAutoScaling: enableAutoScaling
        vnetSubnetID: subnetRef
        // availabilityZones
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    nodeResourceGroup: nodeResourceGroup
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
    }
  }
  sku: {
    name: 'Basic'
    tier: aksTier
  }
}

output id string = aks.id
output apiServerAddress string = aks.properties.fqdn
