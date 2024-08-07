#!/bin/bash


source scripts/config_files/deployment_config.sh

cp scripts/auxiliary_files/endpoint_aml.yml scripts/auxiliary_files/actual_endpoint_aml.yml
sed -i "s/endpoint_name_placeholder/${endpoint_name}/g" scripts/auxiliary_files/actual_endpoint_aml.yml

echo "Creating Online Endpoint ${endpoint_name}"
az ml online-endpoint create -f scripts/auxiliary_files/actual_endpoint_aml.yml --resource-group $resource_group --workspace-name $workspace

rm scripts/auxiliary_files/actual_endpoint_aml.yml