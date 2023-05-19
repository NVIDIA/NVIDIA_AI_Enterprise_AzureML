#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"

cd bodypose2d
./register_model.sh
cd ../deepstream-app
./register_model.sh
cd ../ds-tao-detection
./register_model.sh
cd ../ds-tao-segmentation
./register_model.sh
cd ../emotion
./register_model.sh
cd ../faciallandmark
./register_model.sh
cd ../gaze
./register_model.sh
cd ../gesture
./register_model.sh
cd ../lpr
./register_model.sh
cd ../mdx-perception
./register_model.sh
cd ..

