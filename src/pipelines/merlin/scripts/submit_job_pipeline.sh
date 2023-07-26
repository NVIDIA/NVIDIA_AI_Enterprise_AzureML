#!/bin/bash
# submitting pipeline as defined by pipelines/pipeline.yml as a job 
source scripts/config_files/config.sh
az ml job create --file pipelines/${workflow}/pipeline.yml