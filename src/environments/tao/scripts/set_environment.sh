#!/bin/bash

source scripts/config_files/config.sh
az ml environment create --registry-name ${registry_name} --file environments/${nvidia_product}/${container}/${nvidia_product}.yml