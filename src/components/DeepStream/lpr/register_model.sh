#!/bin/bash

az ml model create --name lpr --path data/models/LP --registry-name $REGISTRY --type custom_model --version 1 --tags 'NVIDIA AI Enterprise' 'Preview'