//Define Azure Files parmeters
param location string {
  default: resourceGroup().location
  metadata: {
    description: 'Specifies the Azure location where the resource should be created.'
  }
}

param storagePrefix string {
  default: 'prefix'
  metadata: {
    description: 'Specifies the prefix'
  }
}

param storageaccountName string {
  // default: [concat('storage', uniqueString(resourceGroup().id))]
  default: '${storagePrefix}${uniqueString(resourceGroup().id)}'
  metadata: {
    description: 'Specifies the name of the Azure Storage account.'
  }
}

param storageTier string {
  default: 'Standard'
  metadata: {
    description: 'Specifies the name of the Azure Storage account.'
    allowed: [
      'Standard'
      'Premium'
    ]
  }
}

param storageSubnet string {
  default: ''
  metadata: {
    description: 'Specifies the subnet id to limit traffic from'
  }
}

var networkAclsOn = {
  bypass: 'AzureServices'
  defaultAction: 'Deny'
  virtualNetworkRules: [
    {
      id: storageSubnet
      action: 'Allow'
    }
  ]
}

var networkAclsOff = {
  defaultAction: 'Allow'
}

param httpsTrafficOnly bool {
  default: true
  metadata: {
    description: 'Specifies https traffic only to storage service if sets to true'
  }
}

param storageHNS bool {
  default: false
  metadata: {
    description: 'Specifies the if HNS is enabled'
  }
}

param blobNFS3 bool {
  default: false
  metadata: {
    description: 'Specifies the if nfs3 is enabled'
  }
}

param storageaccountkind string {
  allowed: [
    'Storage'
    'StorageV2'
    'BlobStorage'
    'FileStorage'
    'BlockBlobStorage'
  ]
  default: 'StorageV2'
  metadata: {
    description: 'Specifies the kind of the Azure Storage account.'
  }
}

param storgeaccountRedundancy string {
  allowed: [
    'Standard_LRS'
    'Standard_GRS'
    'Standard_RAGRS'
    'Standard_ZRS'
    'Premium_LRS'
    'Premium_ZRS'
    'Standard_GZRS'
    'Standard_RAGZRS'
  ]
  default: 'Standard_LRS'
  metadata: {
    description: 'Specifies the redundancy of the Azure Storage account.'
  }
}

//Create Storage account
resource sa 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  name: storageaccountName
  location: location
  kind: storageaccountkind
  sku: {
    name: storgeaccountRedundancy
    tier: storageTier
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    isHnsEnabled: storageHNS
    supportsHttpsTrafficOnly: httpsTrafficOnly
    isNfsV3Enabled: blobNFS3
    networkAcls: length(storageSubnet) > 1 ? networkAclsOn : networkAclsOff
  }
}

output storageAccountName string = '${storageaccountName}'
output storageAccountKey string =  listKeys(sa.name, sa.apiVersion).keys[0].value
