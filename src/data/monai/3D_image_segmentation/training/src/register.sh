#!/bin/bash

# use shell epoch time as the version
az ml data create --registry-name "monai-assets" --file BraTS2021_Data.yaml --set version=1