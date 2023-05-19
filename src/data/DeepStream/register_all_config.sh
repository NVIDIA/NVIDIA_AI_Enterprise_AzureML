#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"

cd bodypose2d
./register_config.sh
cd ../deepstream-app
./register_config.sh
cd ../ds-tao-detection
./register_config.sh
cd ../ds-tao-segmentation
./register_config.sh
cd ../emotion
./register_config.sh
cd ../faciallandmark
./register_config.sh
cd ../gaze
./register_config.sh
cd ../gesture
./register_config.sh
cd ../lpr
./register_config.sh
cd ../mdx-perception
./register_config.sh
cd ..

