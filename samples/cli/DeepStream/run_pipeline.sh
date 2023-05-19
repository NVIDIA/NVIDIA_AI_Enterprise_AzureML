#! /bin/bash

source config.sh

sed -i "s/<pipeline_conn_str>/\"${pipeline_conn_str}\"/g" pipeline_bodypose2d.yml
sed -i 's/<pipeline_container_name>/'"$pipeline_container_name"'/g' pipeline_bodypose2d.yml
sed -i 's/<compute_name>/'"$compute_name"'/g' pipeline_bodypose2d.yml
sed -i 's/<registry_name>/'"$registry_name"'/g' pipeline_bodypose2d.yml

az account set --subscription $subscription
az configure --defaults group=$resource_group workspace=$workspace
az ml job create --file pipeline_bodypose2d.yml

