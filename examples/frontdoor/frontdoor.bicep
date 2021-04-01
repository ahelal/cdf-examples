param frontDoorName string
param webAppName string
param sku string

module frontdoor '../../modules/frontdoor/frontdoor.bicep' = {
  name: 'frontdoor'
  params: {
    frontDoorName: frontDoorName
    backendAddress: webApp.outputs.webAppFQDN
  }
}
output frontdoorFQDN string = '${frontDoorName}.azurefd.net'

module webApp '../../modules/webapp/webapp.bicep' = {
  name: 'webApp'
  params: {
    webAppName: webAppName
    sku: sku
  }
}
output webAppName string = webApp.outputs.webAppName
