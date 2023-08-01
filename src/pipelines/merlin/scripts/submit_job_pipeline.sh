#!/bin/bash
source scripts/config_files/config.sh
az ml job create --file pipelines/${container}/${workflow}/pipeline.yml