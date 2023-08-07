#!/bin/bash

source scripts/config_files/config.sh

az acr login -n ${acr}
docker build -t ${acr}.azurecr.io/merlin-triton:latest -f deployments/${container}/${workflow}/deploy-envdocker/Dockerfile .
docker push ${acr}.azurecr.io/merlin-triton:latest
