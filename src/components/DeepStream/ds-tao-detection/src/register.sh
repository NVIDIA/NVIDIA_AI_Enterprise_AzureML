#!/bin/bash
cp ds-tao-detection.yaml ds-tao-detection_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" ds-tao-detection_actual.yaml
az ml component create --file ds-tao-detection_actual.yaml --registry-name $REGISTRY
rm ds-tao-detection_actual.yaml