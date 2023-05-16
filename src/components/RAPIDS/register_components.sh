#!/bin/bash

#Register prep component
cd Prep_component
az ml component create --file prep.yml --registry-name $REGISTRY

#Register transform component
cd ../Transform_component
az ml component create --file transform.yml --registry-name $REGISTRY

#Register train component
cd ../Train_component
az ml component create --file train.yml --registry-name $REGISTRY

#Register predict component
cd ../Predict_component
az ml component create --file predict.yml --registry-name $REGISTRY

#Register score component
cd ../Score_component
az ml component create --file score.yml --registry-name $REGISTRY

cd ../ 
