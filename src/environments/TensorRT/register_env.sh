#!/bin/bash

az ml environment create --file env_tensorrt.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'