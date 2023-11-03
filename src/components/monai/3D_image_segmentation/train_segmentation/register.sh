#!/bin/bash

cp train_segmentation.yaml train_segmentation_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" train_segmentation_actual.yaml
az ml component create --file train_segmentation_actual.yaml --registry-name $REGISTRY
rm train_segmentation_actual.yaml
