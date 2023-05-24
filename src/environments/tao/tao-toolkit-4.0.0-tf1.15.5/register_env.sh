#!/bin/bash

az ml environment create --file env_tao.yml --registry-name $REGISTRY --tags 'NVIDIA AI Enterprise' 'Preview'