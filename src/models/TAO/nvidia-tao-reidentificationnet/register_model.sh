#!/bin/bash

az ml model create --name nvidia-tao-reidentificationnet --path . --registry-name $REGISTRY --type triton_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview' 'Triton'