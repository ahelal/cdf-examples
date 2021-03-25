param location string = resourceGroup().location
param securityRules array = [
  {
    name: 'ssh'
    properties: {
      priority: 1000
      sourceAddressPrefix: '*'
      protocol: 'Tcp'
      destinationPortRange: '22'
      access: 'Allow'
      direction: 'Inbound'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
    }
  }
  {
    name: 'openvpn'
    properties: {
      priority: 1010
      sourceAddressPrefix: '*'
      protocol: 'Udp'
      destinationPortRange: '1194'
      access: 'Allow'
      direction: 'Inbound'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
    }
  }
]

param name string
param publicIpDnsLabel string = '${name}pip'
param customData string
param adminUsername string
param adminPasswordOrKey string
param authenticationType string = 'password'

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
    authenticationType: authenticationType
    adminUsername: adminUsername
    adminPasswordOrKey: adminPasswordOrKey
    subnetRef: vnet.outputs.subnetRef[0]
    publicIPID: pip.outputs.id
    nsgID: nsg1.outputs.id
    customData: customData
  }
}

module pip '../../modules/pip/pip.bicep' = {
  name: 'pip'
  params: {
    publicIpName: '${name}pip'
    publicIpDnsLabel: publicIpDnsLabel
  }
}

output vmname string = vm.outputs.vmName
output pip string = pip.outputs.ip
output user string = vm.outputs.user
