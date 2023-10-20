#!/bin/bash

az ml model create --name nvidia-tao-citysemsegformer --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model segments cityscapes urban city classes . More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/citysemsegformer'