#!/bin/bash

ls

export REGISTRY=""


export AZURE_ML_CLI_PRIVATE_FEATURES_ENABLED=true

##Create Triton Components by Default
export COMPONENTS_DIR=./


###pipeline components should be created after all regular command components have been created
for component_file in $(find $COMPONENTS_DIR -name '*.yaml');
do   
   cp ${component_file} ${component_file}.backup
   sed -i "s#<REGISTRY>#${REGISTRY}#g" $component_file
   echo "az ml component create --file ${component_file} --registry-name ${REGISTRY}"
   az ml component create --file ${component_file} --registry-name ${REGISTRY};
   mv ${component_file}.backup ${component_file}

done;




