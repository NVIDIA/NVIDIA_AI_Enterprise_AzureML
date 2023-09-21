#!/bin/bash
source ../../../config_files/config.sh

echo registering model GPT-2B to registry: $registry_name

az ml model create --name GPT-2B_nemo --path ./scripts/models/nemo/GPT-2B --type custom_model --version 1 