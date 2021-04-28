param location string = resourceGroup().location

param appServicePlanName string = 'FunctionPlan'

param skuName string = 'EP1'
param skuTeir string = 'ElasticPremium'
param skuSize string = 'EP1'
param skuFamily string = 'EP'
param skuCapacity int = 1

resource plan 'Microsoft.Web/serverFarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  kind: 'elastic'
  sku: {
    name: skuName
    tier: skuTeir
    size: skuSize
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {
    reserved: true
  }
}

// "properties": {
// "name": "blaaa",
// "workerSize": 0,
// "workerSizeId": 0,
// "numberOfWorkers": 1,
// "reserved": true
// },
// "sku": {
// "Tier": "Basic",
// "Name": "b1"
// }

output planID string = plan.id
