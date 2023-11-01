# README

1. Build the container using the `Dockerfile_aml.yml`

```
docker build -t 5d74aef9562a4ac1b4616422f000bf12.azurecr.io/model-server-nvgpt:latest -f Dockerfile_aml.yml .
```
You need to push the image to the Azure container registry which is associated with the AzureML workspace you are using. In above command, mine is `5d74aef9562a4ac1b4616422f000bf12.azurecr.io` and hence pushing it to there using the following command
```
docker push 5d74aef9562a4ac1b4616422f000bf12.azurecr.io/model-server-nvgpt:latest
```
2. Create the endpoint using the `endpoint_aml.yml` file
```
az ml online-endpoint create -f endpoint_aml.yml --resource-group mayani-rg --workspace-name mayani-ws2-europe
```
3. Create the deployment using the `deployment_aml.yml` 
```
az ml online-deployment create -f deployment_aml.yml --resource-group <your resourcegroupname> --workspace-name <your AzureML workspace name>
```

4. Test the deployment using the `client_script_nemo8b.py` script. This script should be run on your machine with either using the `virtual environment` or using docker client image

```
docker run -it -v$(pwd)/client_script_nemo8b.py:/workspace/client_script_nemo8b.py --rm nvcr.io/nvidia/tritonserver:23.01-py3-sdk 
```
It should print out the following
```
python client_script_nemo8b.py 
----
----
Is server ready - True
Is model ready - True
```
