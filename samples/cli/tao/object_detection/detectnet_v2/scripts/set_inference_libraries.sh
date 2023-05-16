#!/bin/bash

echo "Getting the deployment repo"
git clone https://github.com/NVIDIA-AI-IOT/tao-toolkit-triton-apps.git

cp scripts/auxiliary_files/tao_client_aml.py tao-toolkit-triton-apps/tao_triton/python/entrypoints/
cp scripts/auxiliary_files/clustering_config_detectnet.prototxt tao-toolkit-triton-apps/tao_triton/python/clustering_specs/

cd tao-toolkit-triton-apps
sudo apt install python3.8-venv -y
python3 -m venv virtualenv
source virtualenv/bin/activate
pip3 install -r tao_triton/requirements-pip.txt 
pip3 install nvidia-pyindex
pip3 install tritonclient[all]
cd ../
