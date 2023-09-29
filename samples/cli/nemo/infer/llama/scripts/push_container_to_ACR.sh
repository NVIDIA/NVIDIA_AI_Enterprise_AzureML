#!/bin/bash

source scripts/config_files/deployment_config.sh

az login --use-device-code

az account set -s ${subscription_id} 

az configure --defaults group=${resource_group} workspace=${workspace}

echo "Login to Azure Container Registry"
echo "az acr login -n $registryname"
az acr login -n $registryname

echo "Building the new docker image and tag it"
docker build -t $registryname.azurecr.io/tme_genai_model_server -f scripts/auxiliary_files/Dockerfile_aml.yml .

echo "Pushing the image to ACR"
docker push ${registryname}.azurecr.io/tme_genai_model_server:latest


