#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name nemotron-3-8b-chat-4k-steerlm --path ~/models/nemotron-3-8b-chat-4k-steerlm_v1.0 --registry-name $registry_name --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
