#!/bin/sh

export REGISTRY=""

cd bodypose2d
./src/register.sh
cd ../deepstream-app
./src/register.sh
cd ../ds-tao-detection
./src/register.sh
cd ../ds-tao-segmentation
./src/register.sh
cd ../emotion
./src/register.sh
cd ../faciallandmark
./src/register.sh
cd ../gaze
./src/register.sh
cd ../gesture
./src/register.sh
cd ../lpr
./src/register.sh
cd ../mdx-perception
./src/register.sh
cd ..

