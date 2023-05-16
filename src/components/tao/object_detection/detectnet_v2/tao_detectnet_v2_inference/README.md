## [Using Inference on the Model](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#using-inference-on-the-model)
#### This component is a wrapper for the TAO DetectNet_v2 inference command

The <span style="color:red;font-weight:700;font-size:12px">infer</span> task for detectnet_v2 may be used to visualize bboxes and/or generate frame-by-frame KITTI format labels on a single image or directory of images. An example of the command for this task is shown below:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 inference [-h] -e < /path/to/inference/spec/file>
                                -i < /path/to/inference/input>
                                -o < /path/to/inference/output>
                                -k < model key>
</pre>

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-e, --inference_spec:</span> The path to an inference specs file.
* <span style="color:red;font-weight:700;font-size:12px">-i, --inference_input:</span> The directory of input images or a single image for inference.
* <span style="color:red;font-weight:700;font-size:12px">-o, --inference_output:</span> The directory to the output images and labels. The annotated images are in <span style="color:red;font-weight:700;font-size:12px">inference_output/images_annotated</span> and labels are in <span style="color:red;font-weight:700;font-size:12px">inference_output/labels</span>.
* <span style="color:red;font-weight:700;font-size:12px">-k, --enc_key:</span> The key to load the model.

The tool automatically generates bbox rendered images in <span style="color:red;font-weight:700;font-size:12px">output_path/images_annotated</span>. To get the bbox labels in KITTI format, configure the <span style="color:red;font-weight:700;font-size:12px">bbox_handler_config</span> spec file using the <span style="color:red;font-weight:700;font-size:12px">kitti_dump</span> parameter as mentioned here. This will generate the output in <span style="color:red;font-weight:700;font-size:12px">output_path/labels</span>.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> The AzureML location of the base model to be used for inference
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> The hard coded base model location to be used as an evaluation reference on the spec file.

### Components Inputs and Outputs
* inputs:
    * data_dir
    * input_subfolder
    * model_dir
    * model_app_name
    * specfile_reference_model_dir
    * original_specs
    * specs_file
    * key
    * output_subfolder
* outputs:
    * results_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters

* <span style="color:red;font-weight:700;font-size:12px">-e, --inference_spec:</span> ${original_specs}/${specs_file}
* <span style="color:red;font-weight:700;font-size:12px">-i, --inference_input:</span> ${data_dir}/${input_subfolder}
* <span style="color:red;font-weight:700;font-size:12px">-o, --inference_output:</span> ${results_dir}/${model_app_name}
* <span style="color:red;font-weight:700;font-size:12px">-k, --enc_key:</span> ${key}
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> ${model_dir}/${model_app_name}
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> ${specfile_reference_model_dir}