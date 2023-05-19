#!/bin/bash

az ml model create --name citysemsegformer --path citysemsegformer_vdeployable_v1.0 --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name peopleSemSegNet --path peopleSemSegNet --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'