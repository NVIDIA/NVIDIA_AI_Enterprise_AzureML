#!/bin/bash

az ml environment create --file env_clara.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'