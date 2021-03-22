param name string
param location string
param key string

module sshkeys '../../modules/sshkeys/sshkeys.bicep' = {
  name: 'sshkeys'
  params: {
    name: name
    location: location
    key: key
  }
}
