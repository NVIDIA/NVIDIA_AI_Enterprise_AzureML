#!/bin/bash

source scripts/config_files/config_deployment.sh

az ml model create --type triton_model --name ${model_name} --version ${model_version} --path azureml://jobs/${model_job_id}/outputs/${model_job_output_name}/ensemble/
