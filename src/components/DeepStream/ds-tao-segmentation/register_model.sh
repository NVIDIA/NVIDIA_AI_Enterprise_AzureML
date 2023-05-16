#!/bin/bash

az ml model create --name citysemsegformer --path data/models/citysemsegformer_vdeployable_v1.0 --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name peopleSemSegNet --path data/models/peopleSemSegNet --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'