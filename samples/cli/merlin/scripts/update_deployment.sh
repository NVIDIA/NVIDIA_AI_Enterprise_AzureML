#!/bin/bash

source scripts/config_files/config.sh

az ml online-deployment update -f ./deployments/${container}/${workflow}/deploy-model.yml
