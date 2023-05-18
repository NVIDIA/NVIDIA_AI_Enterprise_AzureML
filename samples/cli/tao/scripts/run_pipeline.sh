#!/bin/bash

source scripts/config_files/config.sh

export pipeline_file=../${product_subfolder}/pipeline.yml

export running_pipeline_file=../${product_subfolder}/pipeline_run.yml

cp $pipeline_file $running_pipeline_file

sed -i "s/<gpu-cluster>/${compute_name}/g" $running_pipeline_file
sed -i "s/<registry_name>/${registry_name}/g" $running_pipeline_file
sed -i "s/<num_epochs>/${num_epochs}/g" $running_pipeline_file

cat $running_pipeline_file

echo "az ml job create --file $running_pipeline_file"

az ml job create --file $running_pipeline_file

rm $running_pipeline_file