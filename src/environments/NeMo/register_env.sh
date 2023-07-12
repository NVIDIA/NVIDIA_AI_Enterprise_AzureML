#!/bin/bash

az ml environment create --file env_rapids.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'
