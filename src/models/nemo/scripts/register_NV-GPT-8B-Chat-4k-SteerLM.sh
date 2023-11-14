#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name NV-GPT-8B-Chat-4k-SteerLM --path ./scripts/models/nemo/NV-GPT-8B-Chat-4k-SteerLM --registry-name $registry_name --type triton_model --version 2 --tags 'NVIDIA AI Enterprise' 'Preview'
