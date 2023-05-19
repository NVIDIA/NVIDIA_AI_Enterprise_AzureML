#!/bin/bash
cp mdx-perception.yaml mdx-perception_actual.yaml
sed -i "s#<registry_name>#${REGISTRY}#g" mdx-perception_actual.yaml
az ml component create --file mdx-perception_actual.yaml --registry-name $REGISTRY
rm mdx-perception_actual.yaml