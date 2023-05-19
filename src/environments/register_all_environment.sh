#!/bin/bash

export REGISTRY=""

cd Clara-parabricks
./register_env.sh
cd ../DeepStream/triton
./register_env.sh
cd ../../monai/3D_image_segmentation
cd  inference/src
#./register.sh
cd ../../train/src
#./register.sh
cd ../../../../RAPIDS
./register_env.sh
cd ../../../PyTorch
./register_env.sh
cd ../TAO_Toolkit
./register_env.sh
cd ../Tensorflow
./register_env.sh
cd ../TensorRT
./register_env.sh
cd ../Tritonserver
./register_env.sh


