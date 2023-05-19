#!/bin/bash

cp bodypose2d.yaml bodypose2d_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" bodypose2d_actual.yaml
az ml component create --file bodypose2d_actual.yaml --registry-name $REGISTRY
rm bodypose2d_actual.yaml