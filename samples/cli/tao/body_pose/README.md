# Face Detect AzureML Pipeline using TAO DetectNet_v2 Components

This pipeline implements this [NGC Notebook](https://catalog.ngc.nvidia.com/orgs/nvidia/resources/facenet) 

## <span style="color:green;font-weight:700;font-size:24px">Face Detect Pipeline</span> 

The FaceDetect model detects one or more faces in a given image or video. Compared to the FaceirNet model, this model gives better results with RGB images and smaller faces. The model is based on the NVIDIA DetectNet_v2 detector with ResNet18 as a feature extractor. This architecture, also known as GridBox object detection, uses bounding-box regression on a uniform grid on the input image. The gridbox system divides an input image into a grid that predicts four normalized bounding-box parameters (xc, yc, w, h) and a confidence value per output class. The raw normalized bounding-box and confidence detections need to be post-processed by a clustering algorithm such as DBSCAN or NMS to produce the final bounding-box coordinates and category labels.

The Pipeline yml executes the Pipeline Component: 

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">NVIDIA_AzureML_Components_and_Pipelines\components\tao\tfv3.22.05-tf1.15.4\object_detection\facenet\tao_facenet_pipeline
</pre>

Some of the major steps covered in the pipeline are, but not limited to: 

* Take a pretrained resnet18 model and train a ResNet-18 FaceNet model on the WIDERFACE dataset
* Prune the trained FaceNet model
* Retrain the pruned model to recover lost accuracy
* Export the pruned model
* Run Inference on the trained model

# Body Pose Estimation AzureML Pipeline Component using TAO Bpnet Command Components

This pipeline component implements this [NGC Notebook](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/resources/tao-getting-started/version/4.0.2/files/notebooks/tao_launcher_starter_kit/bpnet/bpnet.ipynb) 

## <span style="color:green;font-weight:700;font-size:24px">Body Pose Estimation Pipeline</span> 

BodyPoseNet is an NVIDIA-developed multi-person body pose estimation network included in the TAO Toolkit. It aims to predict the skeleton for every person in a given input image, which consists of keypoints and the connections between them. BodyPoseNet follows a single-shot, bottom-up methodology, so there is no need for a person detector. The pose/skeleton output is commonly used as input for applications like activity/gesture recognition, fall detection, and posture analysis, among others.

The pipeline job executes the pipeline component [fix me](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/resources/tao-getting-started/version/4.0.2/files/notebooks/tao_launcher_starter_kit/bpnet/bpnet.ipynb) 

Some of the major steps covered in the pipeline are, but not limited to: 
* Downloading and converting the training data
* Downloading the model from the NGC catalog
* Training the model