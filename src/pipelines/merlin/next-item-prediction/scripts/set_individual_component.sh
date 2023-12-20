#!/bin/bash

source scripts/config_files/config.sh

cp ${component_file} ${component_file}.backup
sed -i "s#<registry_name>#${registry_name}#g" $component_file
echo "az ml component create --file ${component_file} --registry-name ${registry_name}"
az ml component create --file ${component_file} --registry-name ${registry_name};
mv ${component_file}.backup ${component_file}


