#!/bin/bash

az ml model create --name nvidia-tao-dinov2-retail-object-recognition --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model is trained by COCO Dataset. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/pretrained_dino_coco'