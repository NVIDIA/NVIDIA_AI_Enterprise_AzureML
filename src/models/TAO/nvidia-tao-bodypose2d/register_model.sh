#!/bin/bash

az ml model create --name nvidia-tao-bodypose2d --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model predicts the skeleton for every person in a given input image. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/bodyposenet'