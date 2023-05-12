// This BICEP script will do simple provisioning of MONAI tutorial workspace

// Usage (sh):
// > az login
// > az account set --name <subscription name>
// > az group create --name <resource group name> --location <region>
// > az deployment group create --template-file .\deployment\bicep\open_sandbox_setup.bicep \
//                              --resource-group <resource group name \
//                              --parameters demoBaseName="MONAI-3D"

targetScope = 'resourceGroup'

// please specify the base name for all resources
@description('Base name of the demo, used for creating all resources as prefix')
param demoBaseName string = 'monai-3d'

@description('Region of the workspace, central storage and compute.')
param workspaceRegion string = resourceGroup().location

// Create Azure Machine Learning workspace
module workspace './modules/azureml/open_azureml_workspace.bicep' = {
  name: '${demoBaseName}-aml-${workspaceRegion}'
  scope: resourceGroup()
  params: {
    defaultComputeName: 'monai-cluster'
    baseName: demoBaseName
    machineLearningName: 'aml-${demoBaseName}'
    machineLearningFriendlyName: 'monai ws'
    machineLearningDescription: 'Azure ML MONAI demo workspace (use for dev purpose only)'
    location: workspaceRegion
  }
}


