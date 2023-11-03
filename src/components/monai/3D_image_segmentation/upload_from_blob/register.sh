#!/bin/bash

cp upload_data_from_blob.yaml upload_data_from_blob_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" upload_data_from_blob_actual.yaml
az ml component create --file upload_data_from_blob_actual.yaml --registry-name $REGISTRY
rm upload_data_from_blob_actual.yaml
