#!/bin/bash
source ../../../config_files/config.sh
#az ml model create --name llama --path ./scripts/models/nemo/llama/ --type triton_model --version 3
az ml model create --name llama --path ./scripts/models/nemo/llama/  --registry-name $registry_name --type triton_model --version 4 --tags 'NVIDIA AI Enterprise' 'Preview'
