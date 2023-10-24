#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name llama_nemo --path /home/azureuser/llama_nemo/ --registry-name $registry_name --type custom_model --version 2 --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name llama_nemo --path /home/azureuser/llama_nemo/ --type custom_model --version 2
