#!/bin/bash
cp emotion.yaml emotion_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" emotion_actual.yaml
az ml component create --file emotion_actual.yaml --registry-name $REGISTRY
rm emotion_actual.yaml