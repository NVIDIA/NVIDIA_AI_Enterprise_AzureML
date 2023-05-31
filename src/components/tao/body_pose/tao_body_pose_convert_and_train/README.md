## Pre-processing the Dataset
#### This component is a wrapper for the TAO `bpnet dataset_convert` command and `bpnet train` command.
#### Excerpt from the [BodyPoseNet Documentation](https://docs.nvidia.com/tao/tao-toolkit/text/bodypose_estimation/bodyposenet.html)

The BodyPoseNet app requires the raw input data to be converted to TFRecords for optimized iteration across the data batches. This can be done using the <span style="color:red;font-weight:700;font-size:12px"> dataset_convert </span> subtask under bpnet. Currently, the COCO format is supported.

The following outlines the bpnet dataset conversion command:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao bpnet dataset_convert
                            -d <path/to/dataset_spec>
                            -o <path_to_output_tfrecords>
                            -m <'train'/'test'>
</pre>


After generating Tfrecords and masks ingestible by the TAO training (done in dataset_convert), you are now ready to start training the bodypose estimation network. This
is automatically done as the next step in this component. 

The following outlines the bpnet train command:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao bpnet train
                            -e <path/to/train_spec>
                            -r <path/to/result directory>
                            -k <key>
                            --gpus <num_gpus>
</pre>


The required spec files contain many other arguments, please refer to the [TAO BodyPoseNet documentation](https://docs.nvidia.com/tao/tao-toolkit/text/bodypose_estimation/bodyposenet.html) to learn more about them. Some of such parameters refer to the specific location of data folders, which have specific hard coded entries on the spec file. However, in the case of an AzureML Job Run, the root directories are unknown before the job runs. Directories are assigned dynamically during execution. Therefore, the Component requires to know both the dynamic location during run time and the hard coded location on the spec file to do the substitution on the fly before executing the TAO `bpnet dataset_convert` and `train`. The Component first updates the spec files and then passes the updated spec files to the TAO command during execution.


### Component Inputs and Outputs
* inputs:
    * specs_dir: directory with the original specs files
    * downloaded_data_dir: directory with the downloaded training data
    * training_data_dir: directory with the downloaded training data
    * validation_data_dir: directory with the downloaded validation data
    * base_model_dir: directory with the downloaded pre-trained TAO bpnet model
    * original_specs_dir: directory with the original specs files
* outputs:
    * updated_data_dir: directory with converted TFrecords, masks, and updated spec files
    * data_dir: directory with the original input data to the component
    * unpruned_model_dir: directory with the trained unpruned model