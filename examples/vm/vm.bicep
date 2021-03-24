
param networkSecurityGroupName string
param location string = resourceGroup().location
param securityRules array

module nsg1 '../../modules/nsg/nsg.bicep' = {
  name: 'nsg1'
  params: {
    networkSecurityGroupName: networkSecurityGroupName
    securityRules: securityRules
  }
}
