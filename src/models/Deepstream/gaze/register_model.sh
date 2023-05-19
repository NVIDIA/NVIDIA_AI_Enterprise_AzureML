#!/bin/bash

az ml model create --name gaze --path gazenet --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'