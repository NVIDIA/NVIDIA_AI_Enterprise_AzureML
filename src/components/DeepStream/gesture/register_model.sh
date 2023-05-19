#!/bin/bash

az ml model create --name gesture --path data/models/gesture --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'