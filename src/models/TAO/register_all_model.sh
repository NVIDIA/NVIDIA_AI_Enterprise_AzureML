#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"

# Please download models from NGC with your NVIDIA AI Enterprise account
# and put them under <model name>/<model name>/1
# 

#az account set --subscription nv-tme-azure
#az configure --defaults group=nv-tme-rg workspace=tme-demo-ml

az account set --subscription NV-WWFO
az configure --defaults group=jwu-ml workspace=jwuwestus2
export REGISTRY="jwu-registry"

cd nvidia-tao-bodypose2d
chmod 777 register_model.sh
./register_model.sh
cd ..

