#!/bin/bash

az ml environment create --file env_tritonserver.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'