#!/bin/sh


export REGISTRY=""


./download_models.sh
./copy_models.sh
rm -f models
./register_all_config.sh
./register_all_model.sh
./register_all_component.sh