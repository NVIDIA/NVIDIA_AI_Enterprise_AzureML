#!/bin/bash

cp monai_train_pipeline.yaml monai_train_pipeline_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" monai_train_pipeline_actual.yaml
az ml component create --file monai_train_pipeline_actual.yaml --registry-name $REGISTRY
rm monai_train_pipeline_actual.yaml
