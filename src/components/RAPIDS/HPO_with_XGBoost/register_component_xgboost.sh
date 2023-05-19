#!/bin/bash

#Register prep component
cd prep_data_component
az ml component create --file prep_data.yml --registry-name $REGISTRY
