#!/bin/bash
cp faciallandmark.yaml faciallandmark_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" faciallandmark_actual.yaml
az ml component create --file faciallandmark_actual.yaml --registry-name $REGISTRY
rm faciallandmark_actual.yaml