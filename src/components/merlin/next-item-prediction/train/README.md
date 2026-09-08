# Next Item Prediction - Data Prep Component
## Training Overview: 
In the training step, we will train a model on our preprocessed data & package it for inference on Triton. 


If you would like to learn more, please refer to the follow tech brief sections: [Model Training](https://docs.nvidia.com/ai-enterprise/workflows-recommender-systems-ai/0.1.0/combined-development.html#feature-engineering-model-training) and [Exporting for Serving](https://docs.nvidia.com/ai-enterprise/workflows-recommender-systems-ai/0.1.0/combined-development.html#exporting-for-serving)

## Component inputs & outputs: 
- inputs: 
    - train_input: Takes in preprocessed data to train the model on 
- outputs: 
    - train_output: Triton model, ready for deployment  