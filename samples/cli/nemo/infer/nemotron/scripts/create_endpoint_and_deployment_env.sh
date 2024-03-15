#!/bin/bash


source scripts/config_files/deployment_config.sh

echo "Creating Online Endpoint"
az ml online-endpoint create -f scripts/auxiliary_files/endpoint_aml.yml --resource-group $resource_group --workspace-name $workspace

cp scripts/auxiliary_files/deployment_env_aml.yml scripts/auxiliary_files/actual_deployment_aml.yml

sed -i "s/registryname/${registryname}/g" scripts/auxiliary_files/actual_deployment_aml.yml

echo "Creating Online Deployment"
more scripts/auxiliary_files/actual_deployment_aml.yml
az ml online-deployment create -f scripts/auxiliary_files/actual_deployment_aml.yml

rm scripts/auxiliary_files/actual_deployment_aml.yml
