#!/bin/bash

az ml model create --name deepstream-app --path tao_pretrained_models --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
