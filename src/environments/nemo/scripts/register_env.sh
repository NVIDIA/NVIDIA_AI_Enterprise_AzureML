#!/bin/bash
source ../../../config_files/config.sh
az ml environment create --file env_nemo.yml --registry-name ${registry_name} --tags 'NVIDIA AI Enterprise' 'Preview'