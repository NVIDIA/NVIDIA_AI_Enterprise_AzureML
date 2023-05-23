# Face Detect AzureML Pipeline Component using TAO DetectNet_v2 Command Components

This pipeline implements this [NGC Notebook](https://catalog.ngc.nvidia.com/orgs/nvidia/resources/facenet) 

## <span style="color:green;font-weight:700;font-size:24px">Face Detect Pipeline</span> 

The FaceDetect model detects one or more faces in a given image or video. Compared to the FaceirNet model, this model gives better results with RGB images and smaller faces. The model is based on the NVIDIA DetectNet_v2 detector with ResNet18 as a feature extractor. This architecture, also known as GridBox object detection, uses bounding-box regression on a uniform grid on the input image. The gridbox system divides an input image into a grid that predicts four normalized bounding-box parameters (xc, yc, w, h) and a confidence value per output class. The raw normalized bounding-box and confidence detections need to be post-processed by a clustering algorithm such as DBSCAN or NMS to produce the final bounding-box coordinates and category labels.

Some of the major steps covered in the pipeline are, but not limited to: 

* Take a pretrained resnet18 model and train a ResNet-18 FaceNet model on the WIDERFACE dataset
* Prune the trained FaceNet model
* Retrain the pruned model to recover lost accuracy
* Export the pruned model
* Run Inference on the trained model


 
