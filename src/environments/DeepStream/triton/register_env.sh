#!/bin/bash

az ml environment create --file ds_env.yaml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'