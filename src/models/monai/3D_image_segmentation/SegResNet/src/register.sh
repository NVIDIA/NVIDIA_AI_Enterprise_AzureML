\# create model in registry
az ml model create --name monai-3d-segmentation --version 1 --type mlflow_model --path ./model/ --registry-name NVIDIARegistryTest1
