#!/bin/bash
source ../../../config_files/config.sh
az ml model create --name llama_trt_llm --path /home/azureuser//NeMoMicroservices/model-store --registry-name $registry_name --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
