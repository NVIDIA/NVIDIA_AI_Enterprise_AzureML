#!/bin/bash

source scripts/config_files/config.sh

az ml online-deployment create -f ./deployments/${container}/${workflow}/deploy-model.yml

