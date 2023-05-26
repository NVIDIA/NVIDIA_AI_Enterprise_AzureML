# DeepStream Components

NVidia AI Enterprise has recently launched a collection of curated TAO models, enabling users to quickly get started with their AI projects. They have also provided a set of Docker images, allowing users to fine-tune these models as per their requirements. In addition, Deepstream serves as an effective inference tool, making it ideal for testing both the TAO-provided models and the user's own fine-tuned models.

Deepstream offers numerous samples that demonstrate its usage in various scenarios. Furthermore, the Deepstream Azure ML components build upon these samples, offering a streamlined interface and improved accessibility. This integration brings together the power of Deepstream and Azure ML, making it easier for users to utilize and locate the resources they need for their projects.

## Usage scenario of Deepstream Azure component


* For beginners, you can utilize the pre-existing models and configurations provided to easily run the components. Simply place the video in the input queue and retrieve the processed video from the output queue.

* If you have more experience, you can leverage TAO to fine-tune the models, enhancing the output performance when used in conjunction with Deepstream.

* Advanced users have the option to modify the Deepstream configuration, particularly if they possess expertise in the Deepstream SDK.

* Developers can delve into the source code of the components and make modifications as needed. For instance, you can send the inference metadata to an IoT Hub for further processing and perform other customizations.

### Following image shows the usage scenario of Deepstream Azure component

We create Deepstream component for each TAO model.  They have unified user intefrace for quick start. Each component has three inputs.

* config from data in registry
* models from model in registry
* parameters for input/output video in azure storage blob

![](./imgs/usage.jpg)

## Relationship between TAO model, deepstream app and Deepstream Azure component

This sectionis for user want to know more about specific model, sample code.  The relationship between models and components are many to many.  Some models are used by several components and some components use several models.  Please follow indivisual link for more details.

* [bodypose 2d](./bodypose2d/README.md)
![](https://developer.nvidia.com/sites/default/files/akamai/TLT/bodyposenet/nv_pose2d_1.png)
* [dashcamnet, trafficcamnet, vehiclemakenet, vehicletypenet, peopleNet](./deepstream-app/README.md)
![](https://developer.nvidia.com/sites/default/files/akamai/NGC_Images/models/trafficcamnet/000020_output.jpg)
![](https://developer.nvidia.com/sites/default/files/akamai/NGC_Images/models/peoplenet/output_11ft45deg_000070.jpg)
* [peoplenet transformer, retail object detection](./ds-tao-detection/README.md)
![](https://github.com/vpraveen-nv/model_card_images/raw/main/cv/purpose_built_models/peoplenet_transformer/peoplenet_transformer.jpg)
* [people segmentation, city segmentation](./ds-tao-segmentation/README.md)
![](https://github.com/vpraveen-nv/model_card_images/raw/main/cv/purpose_built_models/citysemsegformer/001167.jpg)
![](https://developer.nvidia.com/sites/default/files/akamai/TLT/peoplesemsegnet_sample_inference.jpg)
* [emotion](./emotion/README.md)
* [facial landmark](./faciallandmark/README.md)
![](https://developer.nvidia.com/sites/default/files/akamai/TLT/fpe_sample_keypoints.png)
* [gaze](./gaze/README.md)
![](https://developer.nvidia.com/sites/default/files/akamai/TLT/gaze_use_case_image_IX.png)
* [gesture](./gesture/README.md)
* [license plate recognition](./lpr/README.md)
![](https://github.com/NVIDIA-AI-IOT/deepstream_lpr_app/raw/master/lpr.png)
* [people re-identification, retail object recognition](./mdx-perception/README.md)

Following image shows the relationship between TAO model, deepstream app and Deepstream Azure component

![](./imgs/ds_components.jpg)

## Deployment

Everything should be already in Azure ML registry and ready to use.
Please make sure component component, config and model are all registed before use them. Details are at corresponding folder if you want to use your own registry.

* src/data/Deepstream/register_all_config.sh
* src/environments/DeepStream/triton/register_env.sh
* src/models/Deepstream/register_all_model.sh
* src/components/Deepstream/register_all_components.sh

## Run

All components feature a uniform user interface for ease of design usage.

* drag and drop components to designer
* drag and drop corresponding model to designer and connect to component
* drag and drop corresponding config to designer and connect to component
* fill up the connection infomation in component's parameters
* deepstream-app, ds-tao-detection and dds-tao-segmentation can handle multiple models.  they have one more parameters for it.
* select computer and submit and wait for 10-40 minutes for initialization to start process video.
* To save the initialization time,  The component is designed to run forever and wait for video for process.  For development and testing, put any file with file name end with .end in inputs folder will break the loop.

Please reference indivisual README.md file for each component for more detail.  Links are provided in aboved section.
