#!/bin/bash
source ../../../../../config_files/config.sh

echo registering models megatron_gpt_345m_nemo and megatron_gpt_345m_nemo_w to registry: $registry_name

az ml model create --name megatron_gpt_345m_nemo --path ./megatron_gpt_345m.nemo --registry-name $registry_name --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name megatron_gpt_345m_nemo_w --path ./megatron_gpt_345m.nemo --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'