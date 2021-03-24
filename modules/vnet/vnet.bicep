// Azure virtual network

// virtual network name'
param virtualNetworkName string = 'vnet'
// Resource Name
param location string = resourceGroup().location

@description('Specifies the Azure tags that will be assigned to the resource.')
param tags object = {
  environment: 'test'
}

@description('Specifies the Azure vnet address where the resource should be created.')
param addressPrefixes array = [
  '192.168.0.0/16'
]

@description('Specifies the Azure vnet address where the resource should be created.')
param subnets array = [
  {
    name: 'subnet01'
    prefix: '192.168.0.0/16'
    endpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
  }
]

resource vn 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [for subnet in subnets: {
      name: subnet.Name
      properties: {
        addressPrefix: subnet.prefix
        serviceEndpoints: subnet.endpoints
      }
    }]
  }
}

output vnetID string = '${vn.id}'
output subnetRef array = [for s in subnets: '${vn.id}/subnets/${s.name}']
