#!/bin/bash

echo "Building the container"
docker build -f "tao-toolkit-triton-apps/docker/Dockerfile" \
             -t nvcr.io/nvidia/tao/triton-apps:22.06-py3 tao-toolkit-triton-apps