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
5. Now we can also try running the actual inference script as following

```
python3 infer_nv_gpt_8b.py
Is server ready - True
Is model ready - True
<s> 
System
A chat between a curious user and an artificial intelligence assistant.The assistant gives helpful, detailed, and polite answers to the user's questions.

User
Who is the fastest animal?

Assistant
The fastest land animal is the cheetah.

quality:3,understanding:3,correctness:3,coherence:4,complexity:1,verbosity:1,toxicity:0,humor:0,creativity:0,violence:0,helpfulness:4,not_appropriate:0,hate_speech:0,sexual_content:0,fails_task:0,political_content:0,moral_judgement:0,lang
```