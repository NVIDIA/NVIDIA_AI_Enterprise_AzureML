#!/bin/bash

source scripts/config_files/deployment_config.sh

CREATE_KEYVAULT=false
USE_KEYVAULT=false
CREATE_ENDPOINT=false
PUSH_CONTAINER_TO_ACR=false
CREATE_DEPLOYMENT=false
DEPLOYMENT_TYPE=""

for i in "$@"; do
  case $i in
    --create_keyvault)
      CREATE_KEYVAULT=true
      shift # past argument with no value
      ;;
    --use_keyvault)
      USE_KEYVAULT=true
      shift # past argument with no value
      ;;
    --create_endpoint)
      CREATE_ENDPOINT=true
      shift # past argument with no value
      ;;
    --push_container_to_acr)
      PUSH_CONTAINER_TO_ACR=true
      shift # past argument with no value
      ;;
    --create_deployment)
      CREATE_DEPLOYMENT=true
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

echo "CREATE_KEYVAULT $CREATE_KEYVAULT"

if ${CREATE_KEYVAULT}
then
    echo "Creating Key vault"
    scripts/set_key_vault.sh
else
    echo "Set Credentials"
    scripts/set_credentials.sh
fi

if ${CREATE_ENDPOINT}
then
    echo "Creating Endpoint"
    scripts/create_endpoint.sh
fi

if ${PUSH_CONTAINER_TO_ACR}
then
    echo "Pushing Container to ACR"
    scripts/push_container_to_ACR.sh
fi

if ${USE_KEYVAULT}
then
    echo "Pushing Container to ACR"
    scripts/create_role_assignment.sh
fi

if ${CREATE_DEPLOYMENT}
then
    echo "Parsing Deployment Type: ${DEPLOYMENT_TYPE}"
    if [[ "${DEPLOYMENT_TYPE}" == "ACR" || "${DEPLOYMENT_TYPE}" == "REGISTRY" ]]
    then
        echo "Creating Deployment"
        if ${USE_KEYVAULT}
        then
            echo "scripts/create_deployment.sh --use_keyvault --deployment_type=$DEPLOYMENT_TYPE"
            scripts/create_deployment.sh --use_keyvault --deployment_type=$DEPLOYMENT_TYPE
        else
            echo "scripts/create_deployment.sh --deployment_type=$DEPLOYMENT_TYPE"
            scripts/create_deployment.sh --deployment_type=$DEPLOYMENT_TYPE
        fi
    else
        echo "Unsupported Deployment Type"
        exit 1
    fi
fi