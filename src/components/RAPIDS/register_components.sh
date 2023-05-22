#!/bin/bash

export REGISTRY=""


export AZURE_ML_CLI_PRIVATE_FEATURES_ENABLED=true

##Create Triton Components by Default
export COMPONENTS_DIR=./

SUB='pipeline'
###pipeline components should be created after all regular command components have been created
for component_file in $(find $COMPONENTS_DIR -name '*.yml');
do
    if [[ "$component_file" != *"$SUB"* ]]; then
        cp ${component_file} ${component_file}.backup
        sed -i "s#<REGISTRY>#${REGISTRY}#g" $component_file
        echo "az ml component create --file ${component_file} --registry-name ${REGISTRY}"
        az ml component create --file ${component_file} --registry-name ${REGISTRY};
        mv ${component_file}.backup ${component_file}
    fi
done;

for component_file in $(find $COMPONENTS_DIR -name '*.yml');
do
    if [[ "$component_file" == *"$SUB"* ]]; then
        cp ${component_file} ${component_file}.backup
        sed -i "s#<REGISTRY>#${REGISTRY}#g" $component_file        
        echo "az ml component create --file ${component_file} --registry-name ${REGISTRY}"
        az ml component create --file ${component_file} --registry-name ${REGISTRY};
        mv ${component_file}.backup ${component_file}
    fi
done;


