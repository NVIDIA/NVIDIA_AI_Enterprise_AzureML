#!/bin/bash
source config_files/config.sh
az ml model create --name megatron_gpt_345m_nemo --path ./ --registry-name $registry_name --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'