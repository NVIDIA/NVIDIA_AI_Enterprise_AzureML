#!/bin/bash

echo "Pulling the container"
sudo docker login nvcr.io
sudo docker pull nvcr.io/nvidian/nemo-llm/nemollm-inference-trt-only:24.01.rc2