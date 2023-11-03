#!/bin/bash

az ml model create --name nvidia-tao-gesture --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model classify hand crop images into 5 gesture types. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/gesturenet'