#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"
#export REGISTRY="ams-components"

./download_models.sh
./copy_models.sh
rm -f models
./register_all_config.sh
./register_all_model.sh
./register_all_component.sh