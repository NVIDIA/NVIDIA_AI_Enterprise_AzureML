#!/bin/bash
set -x

source scripts/config_files/deployment_config.sh

scripts/set_credentials.sh
echo "az keyvault create --name ${keyvault_name} --resource-group ${resource_group} --location ${location}"
az keyvault create --name ${keyvault_name} --resource-group ${resource_group} --location ${location}
az role assignment create --role "Key Vault Secrets User" --assignee ${email_address}  --scope "/subscriptions/${subscription_id}/resourceGroups/${resource_group}/providers/Microsoft.KeyVault/vaults/${keyvault_name}"
az keyvault secret set --vault-name ${keyvault_name} --name "NGC-KEY" --value ${ngc_key}
az keyvault secret show --vault-name ${keyvault_name}  --name "NGC-KEY"