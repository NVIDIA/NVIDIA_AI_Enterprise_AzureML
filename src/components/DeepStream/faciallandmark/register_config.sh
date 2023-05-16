#!/bin/bash

#az ml data create --name faciallandmark_config --path data --registry-name "NVIDIARegistryTest1" --type uri_folder --version 1
az ml data create --file data.yml --registry-name $REGISTRY --version 1  