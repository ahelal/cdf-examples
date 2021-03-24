
param location string = resourceGroup().location
param securityRules array
param name string 

module nsg1 '../../modules/nsg/nsg.bicep' = {
  name: 'nsg1'
  params: {
    networkSecurityGroupName: '${name}nsg'
    securityRules: securityRules
  }
}

module vnet '../../modules/vnet/vnet.bicep' = {
  name: 'vnet'
  params: {
      virtualNetworkName: '${name}vnet'
      location: location
  }
}

module vm '../../modules/ubuntu/ubuntu.bicep' = {
  name: 'vm1'
  params: {
    vmName: '${name}vm'
    adminPasswordOrKey: 'Adk2kdkfkS1! '
    subnetRef: vnet.outputs.subnetRef[0]
    publicIPID: pip.outputs.id
  }
}

module pip '../../modules/pip/pip.bicep' = {
  name: 'pip'
  params: {
    publicIpName: '${name}pip'
  }
}
