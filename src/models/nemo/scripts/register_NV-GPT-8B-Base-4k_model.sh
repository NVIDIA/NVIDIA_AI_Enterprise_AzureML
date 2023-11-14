#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name NV-GPT-8B-Base-4k --path ./scripts/models/nemo/NV-GPT-8B-Base-4k --registry-name $registry_name --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
