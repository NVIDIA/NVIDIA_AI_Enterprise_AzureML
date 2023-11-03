#!/bin/bash

az ml model create --name nvidia-monai-segresnet --path ./model --registry-name $REGISTRY --type mlflow_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'
