# Next Item Prediciton Workflow in AzureML

This pipeline implements the [Next Item Prediction Workflow](https://docs.nvidia.com/ai-enterprise/workflows-recommender-systems-ai/0.1.0/combined-development.html#undefined). Note: The entire workflow is *not* implemented in a pipeline; only the steps up to training the model are included. Model registration, and endpoint/ deployment setup are run separately through different scripts. 

## How to run the pipeline 

The user should edit the following config file in scripts/config_files/config.sh

<img src=" add it in thanks">

The ACR parameter can be left blank till the deployment step. 
The remaining parameters are defined here: 
- subscription_id = user's subscription id
- resource_group = resource group the user intends to run the pipeline under 
- worksapce = workspace the user intends to run the pipeline in 
- compute_name = compute instance the user intends to run the pipeline on 

To set credentials, run the following script: 

```
bash scripts/set_credentials.sh
```

Then, to run the pipeline, run the following script: 

```
bash scripts/submit_job_pipeline.sh
```

## Merlin & Next Item Prediction Pipeline
The next item prediction pipeline is designed to help companies build effective, personalized recommendations using little to no user data. It is based on NVIDIA Merlin™, an end-to-end framework for building, training, optimizing, and deploying recommender systems at any scale. Using Merlin, data scientists and machine learning engineers are empowered to streamline building pipelines for session-based recommendations and more.

The pipeline contains:
- Synthetic data generation 
- Data preprocessing with Merlin
- Training the model 

The pipeline produces a model can be deployed as an AzureML Triton Inference Endpoint. 

## Deployment config file
The info required for deployments is located in ```scripts/config_files/config_deployment.sh```. Notes for each field are included below: 

### Model Job ID
The model_job_id help identify the component that produced the to-be-deployed model. This information is availble through the Azure Portal.

### Contaier Registry Identification
The variable registry_name is the Azure Container Registry that's asosciated with the provided Workspace. This information is availble through the Azure Portal. 

## Deploying the model
Now, we can register the model and deploy it in AzureML with NVIDIA Triton Inference Server™, an open-source inference serving software that helps standardize model deployment and execution and delivers fast and scalable AI in production. We'll first register the model, then build and push the Triton container to the Azure Container Registry (ACR), then create the inference endpoint and the model deployment. 

### Model registration 
We register the model by running the following script: 

```
bash scripts/register_model.sh
```

Once the model is registered, we can verify its existence by clicking the Model tab in the AzureML workspace portal. 

blha blah ablhj inmagesf hgo here

We can further verify that the model is registered under the expected Triton model subfolder structure by clicking at the "Artifacts" tabs under the model dashboard. 

more photos weewoo image here! 

### Setting up Inference Libraries

actually write this script please thanks 

### Building the Triton Container Locally & uploading docker image to Azure Container Registry (ACR) 
To build the Triton Container and push it to the ACR, run the following script: 

```
bash scripts/push_triton_to_acr
```

This will build and tag the Triton image like this: ```{registry_name}.azurecr.io/merlin-trition:latest```, then push it to the ACR 

Once the script finishes running, navigate to the provided ACR in Azure Portal to see your pushed container image 

### Creating the Azure ML Endpoint and Deployment
To create the endpoint, run the following script: 

```
bash scripts/create_endpoint.sh
```

The script runs this command: ```az ml online-endpoint create -n next-item-endpoint -f /inference/triton/endpoint.yml```, which creates an online endpoint according to the specifications in ```inference/triotn/endpoint.yml```

``` 
$schema: https://azuremlschemas.azureedge.net/latest/managedOnlineEndpoint.schema.json
name: next-item-endpoint
auth_mode: aml_token
description: Endpoint for Next Item Prediciton workflow 
```

The endpoint information can be found under the 'Endpoints' tab in the Workspace UI on AzureML Studio. 

image here!

Once the endpoint is properly set up, we can create the deployment by running the following script: 

```
bash scripts/create_deployment.sh 
```
The script creates a deployment via this commnad: 
- az ml online-deployment create -f ./inference/triton/deploy-model.yml 

The deploy-model.yml file contains all information related to deployment creation. This includes which endpoint to use (next-item-endpoint), the previously registered model (next-item:1), the previously pushed docker image (${acr}.azurecr.io/merlin-triton:latest), and the deployment name (next-item-deployment). 

The file also provides the VM Size to be used for the deployment (Standard_NC8as_T4_v3), which is the same compute resource used throughout the rest of this pipeline.

Once the script finishes running, we can view the deployment information on the endpoint's webpage. We can also see information about the deployed model by navigating to the "Deployment Logs" tab. 

image(s) here! 

## Sending inference requests 

To send a sample inference request, run the following script: 
```
bash scripts/sample_request.sh
```
The script automatically gets the proper scoring uri & authentication token using the following two commands:
- az ml online-endpoint show -n $ENDPOINT_NAME --query scoring_uri -o tsv
- az ml online-endpoint get-credentials -n $ENDPOINT_NAME --query accessToken -o tsv

It then run the python script inference/scoring/score.py to send a request to the server 

