#!/bin/bash

source scripts/config_files/config_deployment.sh

az acr login -n ${acr_name}
docker build -t ${acr_name}.azurecr.io/merlin-triton:latest -f ./inference/triton/docker/Dockerfile .
docker push ${acr_name}.azurecr.io/merlin-triton:latest
