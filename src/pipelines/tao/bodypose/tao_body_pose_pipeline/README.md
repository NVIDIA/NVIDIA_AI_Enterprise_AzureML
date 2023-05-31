# Body Pose Estimation AzureML Pipeline Component using TAO Bpnet Command Components

This pipeline implements the BodyPose notebook in TAO Toolkit in [NGC](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/resources/tao-getting-started/files?version=4.0.0). The notebook is located in `notebooks/tao_launcher_starter_kit/bpnet`. Note: The entire notebook is *not* implemented in this pipeline. The notebook is only implemented up to training the model.

## <span style="color:green;font-weight:700;font-size:24px">Body Pose Estimation Pipeline</span> 

BodyPoseNet is an NVIDIA-developed multi-person body pose estimation network included in the TAO Toolkit. It aims to predict the skeleton for every person in a given input image, which consists of keypoints and the connections between them. BodyPoseNet follows a single-shot, bottom-up methodology, so there is no need for a person detector. The pose/skeleton output is commonly used as input for applications like activity/gesture recognition, fall detection, and posture analysis, among others.

Some of the major steps covered in the pipeline are:
* Downloading and converting the training data
* Downloading the model from the NGC catalog
* Training the model
