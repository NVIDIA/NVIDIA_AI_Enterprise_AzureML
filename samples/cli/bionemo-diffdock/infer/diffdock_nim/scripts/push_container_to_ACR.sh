#!/bin/bash

source scripts/config_files/deployment_config.sh
USE_KEYVAULT=false

for i in "$@"; do
  case $i in
    --use_keyvault)
      USE_KEYVAULT=true
      shift # past argument with no value
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

cp scripts/pull_container.sh scripts/actual_pull_container.sh
sed -i "s|ngc_container_placeholder|${ngc_container}|g" scripts/actual_pull_container.sh
more scripts/actual_pull_container.sh
scripts/actual_pull_container.sh
rm scripts/actual_pull_container.sh

echo "Login to Azure Container Registry"
echo "az acr login -n $acr_registry_name"
sudo az acr login -n $acr_registry_name

cp scripts/auxiliary_files/Dockerfile_aml.yml scripts/auxiliary_files/actual_Dockerfile_aml.yml
sed -i "s|ngc_container_placeholder|${ngc_container}|g" scripts/auxiliary_files/actual_Dockerfile_aml.yml
echo "Building the new docker image and tag it"
sudo docker build -t $acr_registry_name.azurecr.io/$image_name -f scripts/auxiliary_files/actual_Dockerfile_aml.yml .

rm scripts/auxiliary_files/actual_Dockerfile_aml.yml

echo "Pushing the image to ACR"
sudo docker push ${acr_registry_name}.azurecr.io/${image_name}:latest


