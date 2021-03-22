// Azure virtual network

param virtualNetworkName string {
  default: 'vnet'
  metadata: {
    description: 'virtual network name'
  }
}

param location string {
  default: resourceGroup().location
  metadata: {
    description: 'Specifies the Azure location where the resource should be created.'
  }
}

param tags object {
  default:{
    environment: 'test'
  }
  metadata: {
    description: 'Specifies the Azure tags that will be assigned to the resource.'
  }
}

param addressPrefixes array {
  default: [ 
    '192.168.0.0/16' 
  ]
  metadata: {
    description: 'Specifies the Azure vnet address where the resource should be created.'
  }
}

param subnets array {
  default: [ 
      {
       name: 'subnet01'
       prefix: '192.168.0.0/16'
       endpoints: [{
                    service: 'Microsoft.Storage'
                  }
                  ]
      }
  ]
  metadata: {
    description: 'Specifies the Azure vnet address where the resource should be created.'
  }
}

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
        serviceEndpoints:  subnet.endpoints
      }
    }]
  }
}

output vnetID string = '${vn.id}'
output subnetRef array = [for s in subnets: '${vn.id}/subnets/${s.name}']
