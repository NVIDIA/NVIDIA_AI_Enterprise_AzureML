#!/bin/sh

export REGISTRY=""

cd train_segmentation
./src/register.sh
cd ../upload_from_blob
./src/register.sh
cd ..
