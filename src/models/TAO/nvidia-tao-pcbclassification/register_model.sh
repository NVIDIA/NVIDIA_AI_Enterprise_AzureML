#!/bin/bash

az ml model create --name nvidia-tao-pcbclassification --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton' --description 'This model detects PCB missing component defects using component level images extracted from a PCB. More information: https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/models/pcb_classification'