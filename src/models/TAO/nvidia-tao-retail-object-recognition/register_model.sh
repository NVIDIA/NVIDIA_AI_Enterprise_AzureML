#!/bin/bash

az ml model create --name nvidia-tao-retail-object-recognition --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model encodes retail items to embedding vectors and predicts their labels. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/retail_object_recognition'