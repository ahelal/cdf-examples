param functionAppName string
param planID string
param location string = resourceGroup().location
param storageAccountName string
param storageAccountKey string

param registryURL string
param registryImage string
param registryTag string
param registryUsername string = ''
param registryPassword string = ''
param InsightKey string = ''

resource functionApp 'Microsoft.Web/sites@2020-06-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: planID
    siteConfig: {
      linuxFxVersion: 'DOCKER|${registryURL}/${registryImage}:${registryTag}'
      use32BitWorkerProcess: false
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccountKey}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionAppName
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://${registryURL}'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_USERNAME'
          value: registryUsername
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_PASSWORD'
          value: registryPassword
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: InsightKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${InsightKey}'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    // httpsOnly: true
  }
}

output functionAppName string = functionApp.name
output functionAppID string = functionApp.id
