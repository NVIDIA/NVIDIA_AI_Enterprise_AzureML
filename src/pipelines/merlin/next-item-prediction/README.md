# Next Item Prediciton Workflow in AzureML

This pipeline implements the Next Item Prediction Workflow. Note: The entire workflow is *not* implemented in this pipeline; only the steps up to training the model are included. 

## Merlin & Next Item Prediction Pipeline
The next item prediction pipeline is designed to help companies build effective, personalized recommendations using little to no user data. It is based on NVIDIA Merlin™, an end-to-end framework for building, training, optimizing, and deploying recommender systems at any scale. Using Merlin, data scientists and machine learning engineers are empowered to streamline building pipelines for session-based recommendations and more.

This pipeline contains:
- Data preprocessing with Merlin
- Training the model 

If running the pipeline for the first time, make sure to run the following scripts in this order: 
- set_environment.sh
- set_components.sh
- submit_job_pipeline.sh 