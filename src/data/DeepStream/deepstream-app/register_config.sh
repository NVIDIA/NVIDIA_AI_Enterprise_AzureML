#!/bin/bash

#az ml data create --name deepstream_app_config --path data --registry-name "NVIDIARegistryTest1" --type uri_folder --version 1  --tags 'NVIDIA AI Enterprise' 'Preview' 
az ml data create --file data.yml --registry-name $REGISTRY --version 1  