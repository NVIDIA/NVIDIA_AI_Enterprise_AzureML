#!/bin/bash

source ../../../config_files/config.sh

echo uploading data to registry: $registry_name

export DATA_DIR=./

for data_file in $(find $DATA_DIR -name '*.yml');
do
    az ml data create --file $data_file --registry-name ${registry_name} --version 1  
done;



