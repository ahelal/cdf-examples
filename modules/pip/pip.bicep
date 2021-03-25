
param publicIpName string
param publicIpDnsLabel string = '${publicIpName}-${newGuid()}'
param location string = resourceGroup().location

@description('Specifies the Azure tags that will be assigned to the resource.')
param tags object = {
  environment: 'test'
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIpName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabel
    }
  }
  tags: tags
}

output fqdn string = publicIp.properties.dnsSettings.fqdn
output ip string = publicIp.properties.ipAddress
output id string = publicIp.id
