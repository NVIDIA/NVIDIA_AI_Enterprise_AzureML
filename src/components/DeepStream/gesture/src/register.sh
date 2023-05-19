#!/bin/bash
cp gesture.yaml gesture_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" gesture_actual.yaml
az ml component create --file gesture_actual.yaml --registry-name $REGISTRY
rm gesture_actual.yaml