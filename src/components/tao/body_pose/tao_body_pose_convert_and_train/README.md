## Pre-processing the Dataset
#### This component is a wrapper for the TAO bpnet dataset_convert command
#### Excerpt from the [BodyPoseNet Documentation](https://docs.nvidia.com/tao/tao-toolkit/text/bodypose_estimation/bodyposenet.html)
The BodyPoseNet app requires the raw input data to be converted to TFRecords for optimized iteration across the data batches. This can be done using the <span style="color:red;font-weight:700;font-size:12px"> dataset_convert </span> subtask under bpnet. Currently, the COCO format is supported.

The following outlines the bpnet dataset conversion command:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao bpnet dataset_convert
                            -d <path/to/dataset_spec>
                            -o <path_to_output_tfrecords>
                            -m <'train'/'test'>
</pre>

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-d, --dataset_spec </span>: The path to the JSON dataset spec containing the config for exporting .tfrecords.
* <span style="color:red;font-weight:700;font-size:12px"> -o, --output_filename </span>: The output file name. Note that this will be appended with <span style="color:red;font-weight:700;font-size:12px"> -fold-<num>-of-<total> </span>

### Optional Arguments
* <span style="color:red;font-weight:700;font-size:12px"> -h, --help </span>: Show the help message.
* <span style="color:red;font-weight:700;font-size:12px"> -m, --mode </span>: This corresponds to the train_data and test_data fields in the spec. The default value is train.
* <span style="color:red;font-weight:700;font-size:12px"> --check_files </span>: Check if the files, including images and masks, exist in the given root data directory.
* <span style="color:red;font-weight:700;font-size:12px"> --generate_masks </span>: Generate and save masks of regions with unlabeled people. This is used for training.

The required spec file, contains many other arguments, please refer to the [spec file documentation](https://docs.nvidia.com/tao/tao-toolkit/text/bodypose_estimation/bodyposenet.html#dataset-preparation) to learn more about them. Some of such parameters refer to the specific location of data folders, which have specific hard coded entries on the spec file. However, in the case of an AzureML Job Run, the root directories are unknown before the job runs. Directories are assigned dynamically during execution. Therefore, the Component requires to know both the dynamic location during run time and the hard coded location on the spec file to do the substitution on the fly before executing the TAO bpnet dataset_convert. The Component first updates the spec files and then passes the updated spec files to the TAO command during execution.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">dataset full path:</span> The AzureML location of the dataset to be converted.
* <span style="color:red;font-weight:700;font-size:12px">dataset reference:</span> The hard coded dataset location on the spec file.
* <span style="color:red;font-weight:700;font-size:12px">annotations full path:</span> The AzureML location of the annotation data.
* <span style="color:red;font-weight:700;font-size:12px">annotations reference:</span> The hard coded annotation data location on the spec file.

### Components Inputs and Outputs
* inputs:
    * specs_dir
    * data_dir
    * dataset_export_spec
    * output_filename
    * specfile_reference_data_dir:
    * mode
    * relative_mask_directory
* outputs:
    * tf_records_dir