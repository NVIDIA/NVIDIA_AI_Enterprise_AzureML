#!/bin/bash

az ml data create --name nycdata_with_rapids --path ./data --registry-name $REGISTRY --type uri_folder --version 1
