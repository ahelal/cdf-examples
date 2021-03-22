
param location string
param storageAccountName string

// module vnet '../../modules/vnet/vnet.bicep' = {
//   name: 'vnet'
//   params: {
//       location: location
//   }
// }
// output vnetID string = vnet.outputs.vnetID
// output subnetsRef array = vnet.outputs.subnetRef

module saSMB '../../modules/sa/sa.bicep' = {
  name: 'sasmb'
  params: {
      storagePrefix: storageAccountName
      location: location
  }
}
output storageAccountName string = saSMB.outputs.storageAccountName

module smbContainer '../../modules/shares/shares.bicep' = {
  name: 'smbContainer'
  params: {
    storageAccountName: saSMB.outputs.storageAccountName
    shareName: 'openvpn'
    protocol: 'SMB'
  }
}

module aci '../../modules/aci/aci.bicep' = {
  name: 'aci'
  params: {
    name: 'openvpn'
    storageAccountName: saSMB.outputs.storageAccountName
    storageAccountKey: saSMB.outputs.storageAccountKey
    storageShareName: 'openvpn'
    
  }
}
