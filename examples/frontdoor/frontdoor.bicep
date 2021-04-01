param frontDoorName string
param webAppName string
param sku string

module frontdoor '../../modules/frontdoor/frontdoor.bicep' = {
  name: 'frontdoor'
  params: {
    frontDoorName: frontDoorName
    backendAddress: webApp.outputs.webAppFQDN
    wafID: frontdoorWaf.outputs.wafID
  }
}
output frontdoorFQDN string = '${frontDoorName}.azurefd.net'

module frontdoorWaf '../../modules/frontdoor/frontdoor-waf.bicep' = {
  name: 'frontdoorWaf'
  params: {
    frontDoorWafName: frontDoorName
  }
}
// output frontdoorFQDN string = '${frontDoorName}.azurefd.net'

module webApp '../../modules/webapp/webapp.bicep' = {
  name: 'webApp'
  params: {
    webAppName: webAppName
    sku: sku
  }
}
output webAppName string = webApp.outputs.webAppName
