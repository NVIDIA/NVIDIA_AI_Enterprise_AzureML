#!/bin/bash

source scripts/config_files/config.sh
echo az ml environment create --registry-name ${registry_name} --file ${container}/${nvidia_product}.yml
az ml environment create --registry-name ${registry_name} --file ${container}/${nvidia_product}.yml