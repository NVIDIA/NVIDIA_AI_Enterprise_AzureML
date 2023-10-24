#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name GPT-2B_nemo --path ./scripts/models/nemo/GPT-2B --registry-name $registry_name --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
