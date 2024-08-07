#!/bin/bash

source scripts/config_files/deployment_config.sh

echo "az role assignment create --assignee ${endpoint_id} --role "Key Vault Secrets User" --scope /subscriptions/${subscription_id}/resourcegroups/${resource_group}/providers/Microsoft.KeyVault/vaults/${keyvault_name}"
az role assignment create --assignee ${endpoint_id} --role "Key Vault Secrets User" --scope /subscriptions/${subscription_id}/resourcegroups/${resource_group}/providers/Microsoft.KeyVault/vaults/${keyvault_name}
