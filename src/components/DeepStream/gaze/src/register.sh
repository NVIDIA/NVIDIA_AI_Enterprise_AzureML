#!/bin/bash
cp gaze.yaml gaze_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" gaze_actual.yaml
az ml component create --file gaze_actual.yaml --registry-name $REGISTRY
rm gaze_actual.yaml