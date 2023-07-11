#!/bin/bash

source scripts/config_files/config.sh
export AZURE_ML_CLI_PRIVATE_FEATURES_ENABLED=true

##Create Triton Components by Default
export component_file=$1

cp ${component_file} ${component_file}.backup
sed -i "s#<registry_name>#${registry_name}#g" $component_file
echo "az ml component create --file ${component_file} --registry-name ${registry_name}"
az ml component create --file ${component_file} --registry-name ${registry_name};
mv ${component_file}.backup ${component_file}


