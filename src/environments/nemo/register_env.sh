#!/bin/bash

az ml environment create --file env_nemo.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'