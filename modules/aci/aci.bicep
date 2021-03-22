param name string
param image string = 'mcr.microsoft.com/azuredocs/aci-helloworld'
param port int = 80
param protocle string = 'TCP'
param cpuCores int = 1
param memoryinGb int = 2

param mountPath string = '/mnt'
param storageAccountName string = ''
param storageAccountKey string = ''
param storageShareName string = ''

var filesharevolume = 'filesharevolume'

@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'
param location string = resourceGroup().location

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: name
  location: location
  properties: {
    containers: [
      {
        name: name
        properties: {
          image: image
          ports: [
            {
              port: port
              protocol: 'TCP'
            }
          ]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryinGb
            }
          }
          volumeMounts: [
            {
              mountPath: mountPath
              name: filesharevolume
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'Public'
      ports: [
        {
          port: port
          protocol: protocle
        }
      ]
    }
    volumes: [
      {
        name: filesharevolume
        azureFile: {
          sharename: storageShareName
          storageAccountName: storageAccountName
          storageAccountKey: storageAccountKey
        }
      }
    ]
  }
}
output containerIPv4Address string = containerGroup.properties.ipAddress.ip
output ACIID string = containerGroup.id
