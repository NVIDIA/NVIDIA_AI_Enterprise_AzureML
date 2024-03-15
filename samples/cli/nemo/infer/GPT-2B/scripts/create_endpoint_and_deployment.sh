#!/bin/bash


source scripts/config_files/deployment_config.sh

echo "Creating Online Endpoint"
az ml online-endpoint create -f scripts/auxiliary_files/endpoint_aml.yml --subscription $subscription_id -g $resource_group -w $workspace
#az ml online-endpoint create --subscription 66a54950-50a7-4b7e-b0c5-66ce29be6486 -g foundationmodeltest_rg -w foundation-model-workspace

cp scripts/auxiliary_files/deployment_aml.yml scripts/auxiliary_files/actual_deployment_aml.yml

sed -i "s/registryname/${registryname}/g" scripts/auxiliary_files/actual_deployment_aml.yml

cat scripts/auxiliary_files/actual_deployment_aml.yml

echo "Creating Online Deployment"
az ml online-deployment create -f scripts/auxiliary_files/actual_deployment_aml.yml  --subscription $subscription_id -g $resource_group -w $workspace

rm scripts/auxiliary_files/actual_deployment_aml.yml
