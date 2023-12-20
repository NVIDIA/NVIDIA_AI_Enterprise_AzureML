#!/bin/bash

source scripts/config_files/config_deployment.sh

sed -i "s/acr_name/${acr_name}/g" ./inference/triton/deploy-model.yml

az ml online-deployment create -f ./inference/triton/deploy-model.yml

