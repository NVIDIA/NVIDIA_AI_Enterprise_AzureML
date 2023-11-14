#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name NV-GPT-8B-Chat-4k-SFT --path ./scripts/models/nemo/NV-GPT-8B-Chat-4k-SFT --registry-name $registry_name --type custom_model --version 2 --tags 'NVIDIA AI Enterprise' 'Preview'
