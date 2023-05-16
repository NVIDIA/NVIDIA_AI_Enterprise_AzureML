#!/bin/bash

az ml model create --name emotion --path data/models/emotion --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'