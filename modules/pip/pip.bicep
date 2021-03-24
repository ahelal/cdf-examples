
param publicIpResourceName string
param publicIpDnsLabel string = '${publicIpResourceName}-${newGuid()}'
param location string = resourceGroup().location

@description('Specifies the Azure tags that will be assigned to the resource.')
param tags object = {
  environment: 'test'
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIpResourceName
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: publicIpDnsLabel
    }
  }
  tags: tags
}

// Set an output which can be accessed by the module consumer
output ipFqdn string = publicIp.properties.dnsSettings.fqdn
output ip string = publicIp.properties.ipAddress
