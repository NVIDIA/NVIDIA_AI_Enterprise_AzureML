## [Generating an INT8 tensorfile Using the calibration_tensorfile Command](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#generating-an-int8-tensorfile-using-the-calibration-tensorfile-command)
## This component is a wrapper for the TAO DetectNet_v2 calibration_tensorfile command

The INT8 tensorfile is a binary file that contains the preprocessed training samples, which may be used to calibrate the model. In this release, TAO Toolkit only supports calibration tensorfile generation for SSD, DSSD, DetectNet_v2, and classification models.

The sample usage for the <span style="color:red;font-weight:700;font-size:12px">calibration_tensorfile</span> command to generate a calibration tensorfile is defined below:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 calibration_tensorfile [-h] -e < path to training experiment spec file>
                                             -o < path to output tensorfile>
                                             -m < maximum number of batches to serialize>
                                            [--use_validation_set]
</pre>

#### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file</span>: The path to the experiment spec file (only required for SSD and FasterRCNN).

* <span style="color:red;font-weight:700;font-size:12px">-o, --output_path</span>: The path to the output tensorfile that will be created.

* <span style="color:red;font-weight:700;font-size:12px">-m, --max_batches</span>: The number of batches of input data to be serialized.

The required spec file, contains many other arguments, please refer to the [spec file documentation](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#creating-a-configuration-file-detectnet-v2) to learn more about them. Some of such parameters refer to the specific location of data folders, which have specific hard coded entries on the spec file, however in the case of an AzureML Job Run, the root directories are unknown as they are assigned dynamically during execution. Then the Component requires to know both the dynamic location during run time and the hard coded location on the spec file to do the substitution on the fly before executing the TAO DetectNet_v2 train. The Component first upgrades the spec files and then passes it to the TAO command during execution.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">base model full path:</span> The AzureML location of the base model to be retrained.
* <span style="color:red;font-weight:700;font-size:12px">base model reference:</span> The hard coded base model location on the spec file.
* <span style="color:red;font-weight:700;font-size:12px">training data folder path:</span> The AzureML location of the data to be used to train the model.
* <span style="color:red;font-weight:700;font-size:12px">training data folder reference:</span> The hard coded training data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder path:</span> The AzureML location of the TF records data required to train the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records training data folder reference:</span> The hard coded TF records training data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">num epochs:</span> Number of epochs to be used while training the model

### Optional Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">validation data folder path:</span> The AzureML location of the data to be used to validate the model.
* <span style="color:red;font-weight:700;font-size:12px">validation data folder reference:</span> The hard coded validation data folder location on the spec file
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder path:</span> The AzureML location of the TF records data required to validate the model.
* <span style="color:red;font-weight:700;font-size:12px">tf records validation data folder reference:</span> The hard coded TF records validation data folder location on the spec file

#### Optional Argument
* <span style="color:red;font-weight:700;font-size:12px">--use_validation_set</span>: A flag specifying whether to use the validation dataset instead of the training set.

The following is a sample command to invoke the calibration_tensorfile command for a classification model:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 calibration_tensorfile
                  -e $SPECS_DIR/classification_retrain_spec.cfg
                  -m 10
                  -o $USER_EXPERIMENT_DIR/export/calibration.tensor
</pre>

### Components Inputs and Outputs

* inputs:
    * model_app_name
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
    * max_batches
    * use_validation_set
    * output_subfolder
    * output_filename
* outputs:
    * output_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters
* <span style="color:red;font-weight:700;font-size:12px">-e, --experiment_spec_file</span>: ${original_specs}/${specs_file}
* <span style="color:red;font-weight:700;font-size:12px">-o, --output_path</span>: ${output_dir}/${model_app_name}/${output_subfolder}/${output_filename}
* <span style="color:red;font-weight:700;font-size:12px">-m, --max_batches</span>: ${max_batches}
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
* <span style="color:red;font-weight:700;font-size:12px">--use_validation_set</span>: ${use_validation_set}