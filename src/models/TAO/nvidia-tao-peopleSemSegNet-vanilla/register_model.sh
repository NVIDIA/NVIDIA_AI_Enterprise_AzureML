#!/bin/bash

az ml model create --name nvidia-tao-peopleSemSegNet-vanilla --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model segments one or more “person” object within an image. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/peoplesemsegnet'