#! /bin/bash

az ml data create --registry-name $REGISTRY --file nyc_parquet_data.yml --version 1
