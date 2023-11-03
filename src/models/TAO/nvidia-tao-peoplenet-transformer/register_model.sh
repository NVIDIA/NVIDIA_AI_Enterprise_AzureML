#!/bin/bash

az ml model create --name nvidia-tao-peoplenet-transformer --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --drscription 'This model detects one or more physical objects from three categories. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/peoplenet_transformer'