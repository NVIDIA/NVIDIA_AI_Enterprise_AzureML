#!/bin/bash

echo "Pulling the container"
sudo docker login nvcr.io
sudo docker pull nvcr.io/ea-bignlp/beta-inf-prerelease/infer:23.08.v7