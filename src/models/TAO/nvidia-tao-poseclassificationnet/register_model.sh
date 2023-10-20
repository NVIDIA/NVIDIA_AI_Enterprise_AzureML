#!/bin/bash

az ml model create --name nvidia-tao-poseclassificationnet --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model is a pose classification network. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/poseclassificationnet'