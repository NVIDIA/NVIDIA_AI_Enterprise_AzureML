# Object Detection AzureML Pipeline Component using TAO DetectNet_v2 Command Components

This pipeline component implements this [NGC Notebook](https://catalog.ngc.nvidia.com/orgs/nvidia/resources/tao_detectnet) 

## <span style="color:green;font-weight:700;font-size:24px">Object Detection Pipeline</span> 

Object detection is a popular computer vision technique that can detect one or multiple objects in a frame and place bounding boxes around them. This sample pipeline provided here, contains a ResNet18 model that you can retrain on an AzureML Compute Cluster, to identify a new set of objects: Car,Cyclist and Pedestrian, simply by running this pipeline.

<img src="imgs/detectnetexample.png" width="900">


Some of the major steps covered in the pipeline are, but not limited to: 

* Setting the environment variables
* Downloading and converting the training data
* Downloading the model from the NGC catalog
* Training the model
* Pruning the model – this removes the unwanted layers, reducing the size of the model
* Retraining the pruned model to recover the lost accuracy
* Quantize Aware Training (QAT) that changes the precision of the model to INT8, reducing the size of the model, without sacrificing accuracy
* Exporting the model for inference


 
