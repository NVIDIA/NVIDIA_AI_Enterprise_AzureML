#!/bin/sh

#export REGISTRY="NVIDIARegistryTest1"

cd bodypose2d
#./src/register.sh
cd ../deepstream-app
#./src/register.sh
cd ../ds-tao-detection
chmod 777 ./src/register.sh
./src/register.sh
cd ../ds-tao-segmentation
chmod 777 ./src/register.sh
./src/register.sh
cd ../emotion
chmod 777 ./src/register.sh
./src/register.sh
#cd ../faciallandmark
#./src/register.sh
#cd ../gaze
#chmod 777 ./src/register.sh
#./src/register.sh
#cd ../gesture
#chmod 777 ./src/register.sh
#./src/register.sh
#cd ../lpr
#chmod 777 ./src/register.sh
#./src/register.sh
#cd ../mdx-perception
#chmod 777 ./src/register.sh
#./src/register.sh
cd ..

