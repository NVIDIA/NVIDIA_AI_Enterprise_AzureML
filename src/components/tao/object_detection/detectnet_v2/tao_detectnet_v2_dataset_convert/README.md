## Pre-processing the Dataset
#### This component is a wrapper for the TAO DetectNet_v2 dataset_convert command
#### Excerpt from the [DetectNet_v2 Documentation](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html)
The DetectNet_v2 app requires the raw input data to be converted to TFRecords for optimized iteration across the data batches. This can be done using the <span style="color:red;font-weight:700;font-size:12px"> dataset_convert </span> subtask under DetectNet_v2. Currently, the KITTI and COCO formats are supported.

The dataset_convert tool requires a configuration file as input. Details of the configuration file and examples are included in the [DetectNet_v2 Documentation](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html).

### Sample Usage of the Dataset Converter Tool
While KITTI is the accepted dataset format for object detection, the DetectNet_v2 trainer requires this data to be converted to TFRecord files for ingestion. The <span style="color:red;font-weight:700;font-size:12px"> dataset_convert </span> tool is described below:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 dataset-convert -d DATASET_EXPORT_SPEC -o OUTPUT_FILENAME
                 [-f VALIDATION_FOLD]
</pre>

You can use the following arguments:

* <span style="color:red;font-weight:700;font-size:12px"> -d, --dataset-export-spec:</span> The path to the detection dataset spec containing the config for exporting .tfrecord files

* <span style="color:red;font-weight:700;font-size:12px"> -o output_filename:</span> The output filename

* <span style="color:red;font-weight:700;font-size:12px"> -f, –validation-fold:</span> The validation fold in 0-based indexing. This is required when modifying the training set, but otherwise optional.

The required spec file, contains many other arguments, please refer to the [spec file documentation](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#creating-a-configuration-file-detectnet-v2) to learn more about them. Some of such parameters refer to the specific location of data folders, which have specific hard coded entries on the spec file, however in the case of an AzureML Job Run, the root directories are unknown as they are assigned dynamically during execution. Then the Component requires to know both the dynamic location during run time and the hard coded location on the spec file to do the substitution on the fly before executing the TAO DetectNet_v2 train. The Component first upgrades the spec files and then passes it to the TAO command during execution.

### Required Arguments to be used for spec file substitution
* <span style="color:red;font-weight:700;font-size:12px">dataset full path:</span> The AzureML location of the dataset to be converted.
* <span style="color:red;font-weight:700;font-size:12px">dataset reference:</span> The hard coded dataset location on the spec file.

The following example shows how to use the command with the dataset:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 dataset_convert  -d < path_to_tfrecords_conversion_spec>
                                       -o < path_to_output_tfrecords>
</pre>

### Components Inputs and Outputs
* inputs:
    * specs_dir
    * data_dir
    * dataset_export_spec
    * output_filename
    * specfile_reference_data_dir:
    * validation_fold
* outputs:
    * tf_records_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters

* <span style="color:red;font-weight:700;font-size:12px"> -d, --dataset-export-spec:</span> ${specs_dir}/${dataset_export_spec}
* <span style="color:red;font-weight:700;font-size:12px"> -o output_filename:</span> ${tf_records_dir}/data/${output_filename}
* <span style="color:red;font-weight:700;font-size:12px"> -f, –validation-fold:</span> ${validation_fold}
* <span style="color:red;font-weight:700;font-size:12px">dataset full path:</span> ${data_dir}/data
* <span style="color:red;font-weight:700;font-size:12px">dataset reference:</span> ${specfile_reference_data_dir}