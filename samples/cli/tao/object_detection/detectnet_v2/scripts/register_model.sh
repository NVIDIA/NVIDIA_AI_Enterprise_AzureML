#!/bin/bash

source scripts/config_files/deployment_config.sh
bash scripts/set_credentials.sh
az ml model create --name ${model_name} --version ${model_version} --path ./model_repository --type triton_model