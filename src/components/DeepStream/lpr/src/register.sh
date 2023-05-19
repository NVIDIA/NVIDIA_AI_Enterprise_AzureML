#!/bin/bash
cp lpr.yaml lpr_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" lpr_actual.yaml
az ml component create --file lpr_actual.yaml --registry-name $REGISTRY
rm lpr_actual.yaml