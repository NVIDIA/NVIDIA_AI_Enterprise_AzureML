## [Pruning the Model](https://docs.nvidia.com/tao/tao-toolkit/text/object_detection/detectnet_v2.html#pruning-the-model)
#### This component is a wrapper for the TAO DetectNet_v2 prune command

Pruning removes parameters from the model to reduce the model size without compromising the integrity of the model itself using the <span style="color:red;font-weight:700;font-size:12px">prune</span> command.

The <span style="color:red;font-weight:700;font-size:12px">prune</span> task includes these parameters:
<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 prune [-h] -pm < pretrained_model>
                            -o < output_file>
                            -k < key>
                            [-n < normalizer>]
                            [-eq < equalization_criterion>]
                            [-pg < pruning_granularity>]
                            [-pth < pruning threshold>]
                            [-nf < min_num_filters>]
                            [-el [< excluded_list>]
</pre>

### Required Arguments
* <span style="color:red;font-weight:700;font-size:12px">-m, --pretrained_model:</span> The path to the original model.
* <span style="color:red;font-weight:700;font-size:12px">-o, --output_file:</span> The path to the output checkpoints.
* <span style="color:red;font-weight:700;font-size:12px">-k, -–key:</span> The encryption key to decrypt the model. This argument is only required with a .tlt model file.

### Optional Arguments
* <span style="color:red;font-weight:700;font-size:12px">-n, –normalizer:</span> Specify <span style="color:red;font-weight:700;font-size:12px">max</span> to normalize by dividing each norm by the maximum norm within a layer; specify L2 to normalize by dividing by the L2 norm of the vector comprising all kernel norms. The default value is <span style="color:red;font-weight:700;font-size:12px">max</span>.
* <span style="color:red;font-weight:700;font-size:12px">-eq, --equalization_criterion:</span> Criteria to equalize the stats of inputs to an element-wise op layer or depth-wise convolutional layer. This parameter is useful for resnets and mobilenets. The options are <span style="color:red;font-weight:700;font-size:12px">arithmetic_mean, geometric_mean, union</span>, and <span style="color:red;font-weight:700;font-size:12px">intersection</span> (default: <span style="color:red;font-weight:700;font-size:12px">union</span>).
* <span style="color:red;font-weight:700;font-size:12px">-pg, -pruning_granularity:</span>The number of filters to remove at a time (default:8)
* <span style="color:red;font-weight:700;font-size:12px">-pth:</span>The threshold to compare the normalized norm against (default:0.1).
* <span style="color:red;font-weight:700;font-size:12px">-nf, --min_num_filters:</span>The minimum number of filters to keep per layer (default:16)
* <span style="color:red;font-weight:700;font-size:12px">-el, --excluded_layers:</span>A list of excluded_layers (e.g. <span style="color:red;font-weight:700;font-size:12px">-pth:</span>-i item1 item2</span>) (default: [])

### Using the Prune Command
Here’s an example of using the <span style="color:red;font-weight:700;font-size:12px">prune</span> task:

<pre style="background-color:rgba(0, 0, 0, 0.0470588)"><font size="2">tao detectnet_v2 prune -m /workspace/output/weights/resnet_003.tlt
                       -o /workspace/output/weights/resnet_003_pruned.tlt
                       -eq union
                       -pth 0.7 -k $KEY
</pre>

### Components Inputs and Outputs
* inputs
    * model_app_name
    * unpruned_model_dir
    * unprunned_model_subfolder
    * unprunned_model_name
    * prunned_model_subfolder
    * prunned_model_name
    * key
    * equalization_criterion
    * pth
    * normalizer
    * excluded_layers
    * pruning_granularity
    * min_num_filters
* outputs:
    * pruned_model_dir

### Components Inputs and Outputs Mapping to TAO Command Parameters

* <span style="color:red;font-weight:700;font-size:12px">-m, --pretrained_model:</span> ${unpruned_model_dir}/${model_app_name}/${unpruned_model_dir}/${unprunned_model_name}
* <span style="color:red;font-weight:700;font-size:12px">-o, --output_file:</span> ${pruned_model_dir}/${model_app_name}/${pruned_model_dir}/${prunned_model_name}
* <span style="color:red;font-weight:700;font-size:12px">-k, -–key:</span> ${key}
* <span style="color:red;font-weight:700;font-size:12px">-n, –normalizer:</span> ${normalizer}
* <span style="color:red;font-weight:700;font-size:12px">-eq, --equalization_criterion:</span> ${equalization_criterion}
* <span style="color:red;font-weight:700;font-size:12px">-pg, -pruning_granularity:</span>${pruning_granularity}
* <span style="color:red;font-weight:700;font-size:12px">-pth:</span> ${pth}
* <span style="color:red;font-weight:700;font-size:12px">-nf, --min_num_filters:</span> ${min_num_filters}
* <span style="color:red;font-weight:700;font-size:12px">-el, --excluded_layers:</span> ${excluded_layers}