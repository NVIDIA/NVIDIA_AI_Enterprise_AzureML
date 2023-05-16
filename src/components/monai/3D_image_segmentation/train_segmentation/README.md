## [Training the Model](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#training-the-model)
#### This component is a using MONAI to train SegResNet model

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-r, --results_dir:</span> The path to a folder where experiment outputs should be written.
* <span style="color:red;font-weight:700;font-size:12px">-k, –key:</span> A user-specific encoding key to save or load a .tlt model.
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file:</span> The path to the spec file. The path may be absolute or relative to the working directory. By default, the spec from spec_loader.py is used.

The required spec file, contains many other arguments, please refer to the [spec file documentation](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#creating-a-configuration-file-detectnet-v2) to learn more about them. Some of such parameters refer to the specific location of data folders, which have specific hard coded entries on the spec file, however in the case of an AzureML Job Run, the root directories are unknown as they are assigned dynamically during execution. Then the Component requires to know both the dynamic location during run time and the hard coded location on the spec file to do the substitution on the fly before executing the TAO DetectNet_v2 train. The Component first upgrades the spec files and then passes it to the TAO command during execution.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> The AzureML location of the base model to be retrained.
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> The hard coded base model location on the spec file.
* <span style="color:red;font-weight:700;font-size:12px">training data folder path:</span> The AzureML location of the data to be used to train the model.
* <span style="color:red;font-weight:700;font-size:12px">training data folder reference:</span> The hard coded training data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder path:</span> The AzureML location of the TF records data required to train the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder reference:</span> The hard coded TF records training data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">num epochs:</span> Number of epochs to be used while training the model (For quick experimentation use values between 3-5, for good training performance use values 120+)

### Optional Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">validation data folder path:</span> The AzureML location of the data to be used to validate the model.
* <span style="color:red;font-weight:700;font-size:12px">validation data folder reference:</span> The hard coded validation data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder path:</span> The AzureML location of the TF records data required to validate the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder reference:</span> The hard coded TF records validation data folder location on the spec file

### Optional Arguments
* <span style="color:red;font-weight:700;font-size:12px">-n, --model_name:</span> The name of the final step model saved. If not provided, defaults to the model.
* <span style="color:red;font-weight:700;font-size:12px">--gpus:</span> The number of GPUs to use and processes to launch for training. The default value is 1.
* <span style="color:red;font-weight:700;font-size:12px">--gpu_index:</span> The indices of the GPUs to use for training. The GPUs are referenced as per the indices mentioned in the ./deviceQuery CUDA samples.
* <span style="color:red;font-weight:700;font-size:12px">--use_amp:</span>  When defined, this flag enables Automatic Mixed Precision mode.
* <span style="color:red;font-weight:700;font-size:12px">--log_file:</span>  The path to the log file. Defaults to stdout.
* <span style="color:red;font-weight:700;font-size:12px">-h, --help:</span>  Show this help message and exit.

### Input Requirement to be specified on the spec file (not to be passed as a Component Ibput)
* Input size: C * W * H (where C = 1 or 3, W > =480, H >=272 and W, H are multiples of 16)
* Image format: JPG, JPEG, PNG
* Label format: KITTI detection

### Sample Usage
Here is an example of a command for training with two GPUs:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 train -e < path_to_spec_file>
                       -r < path_to_experiment_output>
                       -k < key_to_load_the_model>
                       -n < name_string_for_the_model>
                       --gpus 2
</pre>

### Components Inputs and Outputs
* inputs:
    * model_app_name
    * num_epochs
    * training_data_dir
    * training_data_subdir
    * specfile_reference_training_data_dir
    * validation_data_dir
    * validation_data_subdir
    * specfile_reference_validation_data_dir
    * training_tf_records_dir
    * training_tf_records_subdir
    * specfile_reference_training_tf_records_dir
    * validation_tf_records_dir
    * validation_tf_records_subdir
    * specfile_reference_validation_tf_records_dir
    * base_model_dir
    * base_model_subdir
    * specfile_reference_model_dir
    * original_specs
    * specs_file
    * num_gpus
    * key
    * name_string_for_the_model
    * model_subfolder
    * gpu_index
    * use_amp
    * log_file
* outputs:
    * trained_model_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters

* <span style="color:red;font-weight:700;font-size:12px">-r, --results_dir:</span> ${trained_model_dir}/${model_app_name}/${model_subfolder}
* <span style="color:red;font-weight:700;font-size:12px">-k, –key:</span> ${key}
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file:</span> ${original_specs}/${specs_file}
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> ${base_model_dir}/${model_app_name}/${base_model_subdir}
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> ${specfile_reference_model_dir}
* <span style="color:red;font-weight:700;font-size:12px">training data folder path:</span> ${training_data_dir}/${training_data_subdir}
* <span style="color:red;font-weight:700;font-size:12px">training data folder reference:</span> ${specfile_reference_training_data_dir}
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder path:</span> ${training_tf_records_dir}/${training_tf_records_subdir}
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder reference:</span> ${specfile_reference_training_tf_records_dir}
* <span style="color:red;font-weight:700;font-size:12px">num epochs:</span> ${num_epochs}
* <span style="color:red;font-weight:700;font-size:12px">validation data folder path:</span> ${validation_data_dir}/${validation_data_subdir}
* <span style="color:red;font-weight:700;font-size:12px">validation data folder reference:</span> ${specfile_reference_validation_data_dir}
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder path:</span> ${validation_tf_records_dir}/${validation_tf_records_subdir}
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder reference:</span> ${specfile_reference_validation_tf_records_dir}
* <span style="color:red;font-weight:700;font-size:12px">-n, --model_name:</span> ${name_string_for_the_model}
* <span style="color:red;font-weight:700;font-size:12px">--gpus:</span> ${num_gpus}
* <span style="color:red;font-weight:700;font-size:12px">--gpu_index:</span> ${gpu_index}
* <span style="color:red;font-weight:700;font-size:12px">--use_amp:</span>  ${use_amp}
* <span style="color:red;font-weight:700;font-size:12px">--log_file:</span>  ${log_file}
