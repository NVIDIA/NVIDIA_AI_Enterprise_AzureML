#!/bin/bash
cp ds-tao-segmentation.yaml ds-tao-segmentation_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" ds-tao-segmentation_actual.yaml
az ml component create --file ds-tao-segmentation_actual.yaml --registry-name $REGISTRY
rm ds-tao-segmentation_actual.yaml