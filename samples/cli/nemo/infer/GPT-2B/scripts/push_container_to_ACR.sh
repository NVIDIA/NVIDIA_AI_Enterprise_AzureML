#!/bin/bash

source scripts/config_files/deployment_config.sh

echo "Login to Azure Container Registry"
echo "az acr login -n $registryname"
az acr login -n $registryname

echo "Building the new docker image and tag it"
docker build -t $registryname.azurecr.io/nemo_infer_gpt_2b -f scripts/auxiliary_files/Dockerfile2_aml.yml .

echo "Pushing the image to ACR"
docker push ${registryname}.azurecr.io/nemo_infer_gpt_2b:latest