#!/bin/bash

az ml model create --name peoplenet_transformer --path peoplenet_transformer_vdeployable_v1.0 --registry-name $REGISTRY --type custom_model --version 1  --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name retail_object_detection_100 --path retail_object_detection_vdeployable_100_v1.0 --registry-name $REGISTRY --type custom_model --version 1  --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name retail_object_detection_binary --path retail_object_detection_vdeployable_binary_v1.0 --registry-name $REGISTRY --type custom_model --version 1  --tags 'NVIDIA AI Enterprise' 'Preview'