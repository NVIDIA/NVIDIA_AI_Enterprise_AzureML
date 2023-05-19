#!/bin/bash
cp deepstream-app.yaml deepstream-app_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" deepstream-app_actual.yaml
az ml component create --file deepstream-app_actual.yaml --registry-name $REGISTRY
rm deepstream-app_actual.yaml