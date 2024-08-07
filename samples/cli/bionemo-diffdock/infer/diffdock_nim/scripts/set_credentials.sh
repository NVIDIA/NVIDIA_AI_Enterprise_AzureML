#!/bin/bash

source scripts/config_files/deployment_config.sh
az login

az account set -s ${subscription_id} 

echo "az configure --defaults group=${resource_group} workspace=${workspace}"
az configure --defaults group=${resource_group} workspace=${workspace}