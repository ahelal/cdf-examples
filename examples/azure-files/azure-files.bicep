
param location string
param storageAccountName string
param storageShareName string = 'default'

module saSMB '../../modules/sa/sa.bicep' = {
  name: 'sasmb'
  params: {
      storagePrefix: storageAccountName
      location: location
  }
}
output storageAccountName string = saSMB.outputs.storageAccountName
output storageAccountKey string = saSMB.outputs.storageAccountKey

module smbContainer '../../modules/shares/shares.bicep' = {
  name: 'smbContainer'
  params: {
    storageAccountName: saSMB.outputs.storageAccountName
    shareName: storageShareName
    protocol: 'SMB'
  }
}

