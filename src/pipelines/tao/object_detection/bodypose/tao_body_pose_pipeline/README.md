# Body Pose Estimation AzureML Pipeline Component using TAO Bpnet Command Components

This pipeline component implements this [NGC Notebook](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/resources/tao-getting-started/version/4.0.2/files/notebooks/tao_launcher_starter_kit/bpnet/bpnet.ipynb) 

## <span style="color:green;font-weight:700;font-size:24px">Body Pose Estimation Pipeline</span> 

BodyPoseNet is an NVIDIA-developed multi-person body pose estimation network included in the TAO Toolkit. It aims to predict the skeleton for every person in a given input image, which consists of keypoints and the connections between them. BodyPoseNet follows a single-shot, bottom-up methodology, so there is no need for a person detector. The pose/skeleton output is commonly used as input for applications like activity/gesture recognition, fall detection, and posture analysis, among others.

Some of the major steps covered in the pipeline are, but not limited to: 
* Downloading and converting the training data
* Downloading the model from the NGC catalog
* Training the model
* Pruning the model – this removes the unwanted layers, reducing the size of the model
* Retraining the pruned model to recover the lost accuracy
* Exporting the model for inference