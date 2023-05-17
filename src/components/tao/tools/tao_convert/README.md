## [TAO Converter](https://catalog.ngc.nvidia.com/orgs/nvidia/teams/tao/resources/tao-converter)
#### This component is a wrapper for the TAO converter command

Binary to decrypt a .etlt from TAO Toolkit and generate a TensorRT engine

The following outlines the converter command:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao-converter [-h] -k < encryption_key>
                       -d < input_dimensions>
                       -o < comma separated output nodes>
                       [-c < path to calibration cache file>]
                       [-e < path to output engine>]
                       [-b < calibration batch size>]
                       [-m < maximum batch size of the TRT engine>]
                       [-t < engine datatype>]
                       [-w < maximum workspace size of the TRT Engine>]
                       [-i < input dimension ordering>]
                       [-p < optimization_profiles>]
                       [-s]
                       [-u < DLA_core>]
                       input_file
</pre>

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">input_file:</span> Path to the .etlt model exported using tao < model> export.
* <span style="color:red;font-weight:700;font-size:12px">-k:</span> The key used to encode the .tlt model when doing the training.
* <span style="color:red;font-weight:700;font-size:12px">-d:</span> Comma-separated list of input dimensions that should match the dimensions used for tao < model> export.
* <span style="color:red;font-weight:700;font-size:12px">-o:</span> Comma-separated list of output blob names that should match the output configuration used for tao < model> export.

### Optional Arguments
* <span style="color:red;font-weight:700;font-size:12px">-e</span>  Path to save the engine to. (default: ./saved.engine)
* <span style="color:red;font-weight:700;font-size:12px">-t:</span> Desired engine data type, generates calibration cache if in INT8 mode. The default value is fp32. The options are {fp32, fp16, int8}.
* <span style="color:red;font-weight:700;font-size:12px">-w:</span> Maximum workspace size for the TensorRT engine. The default value is 1073741824(1<<30).
* <span style="color:red;font-weight:700;font-size:12px">-i:</span>  Input dimension ordering, all other TAO commands use NCHW. The default value is nchw. The options are {nchw, nhwc, nc}.
* <span style="color:red;font-weight:700;font-size:12px">-p:</span>  Optimization profiles for .etlt models with dynamic shape. Comma separated list of optimization profile shapes in the format < input_name>,< min_shape>,< opt_shape>,< max_shape>, where each shape has the format: < n>x< c>x< h>x< w>. Can be specified multiple times if there are multiple input tensors for the model. This is only useful for new models introduced in TAO Toolkit 3.21.08. This parameter is not required for models that are already existed in TAO Toolkit 2.0.
* <span style="color:red;font-weight:700;font-size:12px">-s:</span>  TensorRT strict type constraints. A Boolean to apply TensorRT strict type constraints when building the TensorRT engine.
* <span style="color:red;font-weight:700;font-size:12px">-u:</span>  Use DLA core. Specifying DLA core index when building the TensorRT engine on Jetson devices.

### INT8 Mode Arguments
* <span style="color:red;font-weight:700;font-size:12px">-c:</span>  Path to calibration cache file, only used in INT8 mode. The default value is ./cal.bin.
* <span style="color:red;font-weight:700;font-size:12px">-b:</span>  Batch size used during the export step for INT8 calibration cache generation. (default: 8).
* <span style="color:red;font-weight:700;font-size:12px">-m:</span>  Maximum batch size for TensorRT engine.(default: 16). If meet with out-of-memory issue, decrease the batch size accordingly. This parameter is not required for .etlt models generated with dynamic shape. (This is only possible for new models introduced in TAO Toolkit 3.21.08.)

### Component Inputs and Outputs
* inputs:
    * model_app_name
    * etlt_model_dir
    * etlt_model_name
    * etlt_model_subfolder
    * trt_model_name
    * trt_model_subfolder
    * key
    * input_dimensions
    * output_nodes
    * cal_cache_dir
    * cal_cache_filename
    * cal_batch_size
    * max_batch_size
    * engine_datatype
    * max_workspace_size
    * input_dimension_ordering
    * optimization_profiles
    * strict_type_constraints
    * dla_core_index
* outputs:
    * trt_model_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters
* <span style="color:red;font-weight:700;font-size:12px">input_file:</span> ${etlt_model_dir}/${model_app_name}/${etlt_model_subfolder}/${etlt_model_name}
* <span style="color:red;font-weight:700;font-size:12px">-k:</span> ${key}
* <span style="color:red;font-weight:700;font-size:12px">-d:</span> ${input_dimensions}
* <span style="color:red;font-weight:700;font-size:12px">-o:</span> ${output_nodes}
* <span style="color:red;font-weight:700;font-size:12px">-e</span> ${trt_model_dir}/${model_app_name}/${trt_model_subfolder}/${trt_model_name} 
* <span style="color:red;font-weight:700;font-size:12px">-t:</span> ${engine_datatype}
* <span style="color:red;font-weight:700;font-size:12px">-w:</span> ${max_workspace_size}
* <span style="color:red;font-weight:700;font-size:12px">-i:</span> ${input_dimension_ordering} 
* <span style="color:red;font-weight:700;font-size:12px">-p:</span> ${optimization_profiles} 
* <span style="color:red;font-weight:700;font-size:12px">-s:</span> ${strict_type_constraints} 
* <span style="color:red;font-weight:700;font-size:12px">-u:</span> ${dla_core_index} 
* <span style="color:red;font-weight:700;font-size:12px">-c:</span> ${cal_cache_dir}/${etlt_model_subfolder}/${cal_cache_filename}
* <span style="color:red;font-weight:700;font-size:12px">-b:</span> ${cal_batch_size} 
* <span style="color:red;font-weight:700;font-size:12px">-m:</span> ${max_batch_size} 


