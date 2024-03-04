#!/bin/bash

echo "Pulling the container"
sudo docker login nvcr.io
sudo docker pull nvcr.io/nv-nvaie-tme/genai-model-server:latest