#!/bin/bash

source ../../../config_files/config.sh

export pipeline_file=$1

export running_pipeline_file=./${pipeline_file}_run.yml

cp $pipeline_file $running_pipeline_file

sed -i "s/<gpu-cluster>/${compute_name}/g" $running_pipeline_file
sed -i "s/<registry_name>/${registry_name}/g" $running_pipeline_file
sed -i "s/<BRANCH>/${branch}/g" $running_pipeline_file
sed -i "s/<workspace_registry_container_id>/${workspace_registry_container_id}/g" $running_pipeline_file
sed -i "s/<location>/${location}/g" $running_pipeline_file

cat $running_pipeline_file

echo "az ml job create --file $running_pipeline_file"

az ml job create --file $running_pipeline_file

rm $running_pipeline_file