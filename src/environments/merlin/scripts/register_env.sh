#!/bin/bash

source scripts/config_files/config.sh
az ml environment create --registry-name ${registry_name} --file environments/${container}/${env}/${container}.yml