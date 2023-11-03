#!/bin/bash

az ml model create --name nvidia-tao-retail-object-detection-100 --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model detects retail items within an image and return a bounding box. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/retail_object_detection'