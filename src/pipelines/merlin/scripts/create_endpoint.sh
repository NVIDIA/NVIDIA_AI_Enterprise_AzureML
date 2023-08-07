#!/bin/bash

source scripts/config_files/config.sh

az ml online-endpoint create -n next-item-endpoint -f ./ebdoiubts/${container}/${workflow}/triton-endpoint.yml
