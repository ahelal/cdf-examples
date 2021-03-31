param aksName string
param location string
param dnsPrefix string
param agentCount int = 1
param agentVMSize string = 'Standard_B2ms'

module vnet '../../modules/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
    location: location
  }
}
output vnetID string = vnet.outputs.vnetID
output subnetsRef array = vnet.outputs.subnetRef

module aks '../../modules/aks/aks.bicep' = {
  name: 'aks'
  params: {
    location: location
    clusterName: aksName
    dnsPrefix: dnsPrefix
    agentCount: agentCount
    agentVMSize: agentVMSize
    subnetRef: vnet.outputs.subnetRef[0]
  }
}
