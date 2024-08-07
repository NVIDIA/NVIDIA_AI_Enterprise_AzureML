#!/bin/bash

USE_KEYVAULT=false
DEPLOYMENT_TYPE=""
source scripts/config_files/deployment_config.sh

for i in "$@"; do
  case $i in
    --use_keyvault)
      USE_KEYVAULT=true
      shift # past argument with no value
      ;;
    --deployment_type=*)
      DEPLOYMENT_TYPE="${i#*=}"
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

if [[ "${DEPLOYMENT_TYPE}" == "ACR" || "${DEPLOYMENT_TYPE}" == "REGISTRY" ]]
then
    echo "Creating Deployment"
    if [[ "${DEPLOYMENT_TYPE}" == "ACR" ]]
    then
        echo "Deployment source ACR"
        cp scripts/auxiliary_files/deployment_acr_aml.yml scripts/auxiliary_files/actual_deployment_aml.yml
    else
        echo "Deployment source Registry"
        cp scripts/auxiliary_files/deployment_env_aml.yml scripts/auxiliary_files/actual_deployment_aml.yml
    fi
else
    echo "Unsupported Deployment Type"
    exit 1
fi

if ${USE_KEYVAULT}
then
    sed -i "s|ngc_key_placeholder|\${{keyvault:https://vault_name_placeholder.vault.azure.net/secrets/NGC-KEY}}|g" scripts/auxiliary_files/actual_deployment_aml.yml
else
    sed -i "s/ngc_key_placeholder/${ngc_key}/g" scripts/auxiliary_files/actual_deployment_aml.yml
fi

sed -i "s/endpoint_name_placeholder/${endpoint_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/deployment_name_placeholder/${deployment_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/acr_registry_placeholder/${acr_registry_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/registry_placeholder/${registry_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/model_name_placeholder/${model_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/model_version_placeholder/${model_version}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/image_name_placeholder/${image_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/environment_version_placeholder/${environment_version}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/instance_type_placeholder/${instance_type}/g" scripts/auxiliary_files/actual_deployment_aml.yml
sed -i "s/vault_name_placeholder/${keyvault_name}/g" scripts/auxiliary_files/actual_deployment_aml.yml
cat scripts/auxiliary_files/actual_deployment_aml.yml
echo "Creating Online Deployment ${deployment_name}"
#az ml online-deployment create -f scripts/auxiliary_files/actual_deployment_aml.yml
#rm scripts/auxiliary_files/actual_deployment_aml.yml