#!/bin/bash

source scripts/config_files/config.sh
export AZURE_ML_CLI_PRIVATE_FEATURES_ENABLED=true

##Create Triton Components by Default
export COMPONENTS_DIR=./

for component_file in $(find $COMPONENTS_DIR -name '*.yml');
do
    cp ${component_file} ${component_file}.actual
    sed -i "s#<registry_name>#${registry_name}#g" $component_file.actual
    echo "az ml component create --file ${component_file}.actual --registry-name ${registry_name}"
    az ml component create --file ${component_file}.actual --registry-name ${registry_name};
    rm ${component_file}.actual
done;


