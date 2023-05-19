#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"

cd bodypose2d
chmod 777 register_model.sh
./register_model.sh
cd ../deepstream-app
chmod 777 register_model.sh
./register_model.sh
cd ../ds-tao-detection
chmod 777 register_model.sh
./register_model.sh
cd ../ds-tao-segmentation
chmod 777 register_model.sh
./register_model.sh
cd ../emotion
chmod 777 register_model.sh
./register_model.sh
cd ../faciallandmark
chmod 777 register_model.sh
./register_model.sh
cd ../gaze
chmod 777 register_model.sh
./register_model.sh
cd ../gesture
chmod 777 register_model.sh
./register_model.sh
cd ../lpr
chmod 777 register_model.sh
./register_model.sh
cd ../mdx-perception
chmod 777 register_model.sh
./register_model.sh
cd ..

