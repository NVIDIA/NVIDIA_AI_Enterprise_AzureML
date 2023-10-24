#!/bin/bash

source ../../../../../config_files/config.sh
az login

az account set -s ${subscription_id} 

echo "az configure --defaults group=${resource_group} workspace=${workspace}"
az configure --defaults group=${resource_group} workspace=${workspace}