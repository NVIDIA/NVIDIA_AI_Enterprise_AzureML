#!/bin/bash

az ml model create --name reidentificationnet --path data/models/reidentificationnet_vdeployable_v1.0 --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
az ml model create --name retail_object_recognition --path data/models/retail_object_recognition_vdeployable_v1.0 --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'