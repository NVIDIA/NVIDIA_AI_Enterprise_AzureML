# Next Item Prediciton Workflow in AzureML

This pipeline implements the Next Item Prediction Workflow. Note: The entire workflow is *not* implemented in this pipeline; only the steps up to training the model are included. Model registration, and endpoint/ deployment setup are run separately through different scripts. 

## Merlin & Next Item Prediction Pipeline
The next item prediction pipeline is designed to help companies build effective, personalized recommendations using little to no user data. It is based on NVIDIA Merlin™, an end-to-end framework for building, training, optimizing, and deploying recommender systems at any scale. Using Merlin, data scientists and machine learning engineers are empowered to streamline building pipelines for session-based recommendations and more.

The pipeline contains:
- Data preprocessing with Merlin
- Training the model 

The full workflow contains: 
- Setting up an endpoint + Triton deployment 
- Sending an inference request to the endpoint

For more information, the website is linked [here]()
## Running the pipeline:
If running the pipeline for the first time, make sure to run the following scripts in this order: 
- set_environment.sh
- set_components.sh
- submit_job_pipeline.sh 

If the environments and compoenents have already been set, only ```submit_job_pipeline.sh``` needs to be run. 

## Setting up endpoint & deployment 
Once the job finishes running, run the following scripts in this order: 
- set_endpoint.sh
- push_triton_to_acr.sh
- create_deployment.sh 

If the Triton image has already been pushed to ACR, the ```push_triton_to_acr.sh``` can be skipped. 
Likewise, the ```set_endpoint.sh``` script can be skipped if the endpoint has already been set up. 

To update an already existing deployment, run ```update_deployment.sh```.

## Sending inference requests 

To send a sample inference request, run the following script: 
- sample_request.sh
