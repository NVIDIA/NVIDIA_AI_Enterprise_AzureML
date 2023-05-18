#!/bin/bash

az ml environment create --file env_tensorflow.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'