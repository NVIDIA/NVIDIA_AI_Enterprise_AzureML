## [Evaluating the Model](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#evaluating-the-model)
#### This component is a wrapper for the TAO DetectNet_v2 evaluate command

Execute <span style="color:red;font-weight:700;font-size:12px">evaluate</span> on a DetectNet_v2 model.

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 evaluate [-h] -e < experiment_spec>
                               -m < model_file>
                               -k < key>
                               [--use_training_set]
                               [--gpu_index]
</pre>

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file:</span> The experiment spec file to set up the evaluation experiment. This should be the same as training spec file.
* <span style="color:red;font-weight:700;font-size:12px">-m, --model:</span> The path to the model file to use for evaluation. This could be a .tlt model file or a tensorrt engine generated using the export tool.
* <span style="color:red;font-weight:700;font-size:12px">-k, -–key:</span> The encryption key to decrypt the model. This argument is only required with a .tlt model file.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> The AzureML location of the base model to be used as an evaluation reference.
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> The hard coded base model location to be used as an evaluation reference on the spec file.
* <span style="color:red;font-weight:700;font-size:12px">training data folder path:</span> The AzureML location of the data to be used to evaluate the model.
* <span style="color:red;font-weight:700;font-size:12px">training data folder reference:</span> The hard coded training data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder path:</span> The AzureML location of the TF records data required to evaluate the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder reference:</span> The hard coded TF records training data folder location on the spec file

### Optional Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">validation data folder path:</span> The AzureML location of the validation data to be used to evaluate the model.
* <span style="color:red;font-weight:700;font-size:12px">validation data folder reference:</span> The hard coded validation data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder path:</span> The AzureML location of the TF records validation data required to evaluate the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder reference:</span> The hard coded TF records validation data folder location on the spec file

### Optional Arguments
* <span style="color:red;font-weight:700;font-size:12px">-h, --help:</span> Show this help message and exit.
* <span style="color:red;font-weight:700;font-size:12px">-f, --framework:</span> The framework to use when running evaluation (choices: “tlt”, “tensorrt”). By default the framework is set to TensorRT.
* <span style="color:red;font-weight:700;font-size:12px">--use_training_set:</span> Set this flag to run evaluation on the training dataset.
* <span style="color:red;font-weight:700;font-size:12px">--gpu_index:</span> The index of the GPU to run evaluation on.

### Sample Usage
If you have followed the example in [Training a Detection Model](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#training-the-model-detectnet-v2), you may now evaluate the model using the following command:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 evaluate -e < path to training spec file>
                          -m < path to the model>
                          -k < key to load the model>
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
    * key
    * gpu_index
    * target_model_dir
    * model_name
    * model_subfolder
    * running_framework
    * use_training_set

### Components Inputs and Outputs Mapping to TAO Command Parameters

* <span style="color:red;font-weight:700;font-size:12px">-m, --model:</span> ${target_model_dir}/${model_app_name}/${model_subfolder}/${model_name}
* <span style="color:red;font-weight:700;font-size:12px">-k, –key:</span> ${key}
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file:</span> ${original_specs}/${specs_file}
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> ${base_model_dir}/${model_app_name}/${base_model_subdir}
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> ${specfile_reference_model_dir}
* <span style="color:red;font-weight:700;font-size:12px">training data folder path:</span> ${training_data_dir}/${training_data_subdir}
* <span style="color:red;font-weight:700;font-size:12px">training data folder reference:</span> ${specfile_reference_training_data_dir}
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder path:</span> ${training_tf_records_dir}/${training_tf_records_subdir}
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder reference:</span> ${specfile_reference_training_tf_records_dir}
* <span style="color:red;font-weight:700;font-size:12px">validation data folder path:</span> ${validation_data_dir}/${validation_data_subdir}
* <span style="color:red;font-weight:700;font-size:12px">validation data folder reference:</span> ${specfile_reference_validation_data_dir}
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder path:</span> ${validation_tf_records_dir}/${validation_tf_records_subdir}
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder reference:</span> ${specfile_reference_validation_tf_records_dir}
* <span style="color:red;font-weight:700;font-size:12px">--gpu_index:</span> ${gpu_index}
* <span style="color:red;font-weight:700;font-size:12px">-f, --framework:</span> ${running_framework}
* <span style="color:red;font-weight:700;font-size:12px">--use_training_set:</span> ${use_training_set}
