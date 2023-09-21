#!/bin/bash

source scripts/config_files/deployment_config.sh
bash scripts/set_credentials.sh
az ml model create --name ${model_name} --version ${model_version} --path azureml://jobs/${model_job_id}/outputs/${model_job_output_name} --type triton_model