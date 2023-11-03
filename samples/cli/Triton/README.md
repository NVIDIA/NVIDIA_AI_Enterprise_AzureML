# Gesture model served with Triton Inference Server

Following link explains how to do the inference using models served in Azure ML via Triton 
https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-with-triton?view=azureml-api-2&tabs=azure-cli%2Cendpoint

more example can be found in this link.
https://github.com/NVIDIA-AI-IOT/tao-toolkit-triton-apps/tree/main 

## Gesture
python triton_gesture_scoring.py --base_url="url to triton server" --token='token' --image_path 'path to image'

## pcbclassification
python triton_pcbclassification_scoring.py --base_url="url to triton server" --token='token' --image_path 'path to image'

## Dino V2 Retail object recognition
python triton_dinov2-retail-object-recognition_scoring.py --base_url="url to triton server" --token='token' --image_path 'path to image'
