## TAO Download Model Component

This component leverages the NGC REGISTRY CLI to download TAO pretrained models

The component first downloads the ngc cli tool and then uses it to download the required pretrained TAO model

### Component Inputs and Outputs

* inputs:
    * model_app_name
    * model_type
    * model_name
    * model_subdir
* outputs
    * base_model_dir

After downloading the tool the Component executes:

ngc registry model download-version nvidia/tao/${model_type}:${model_name} \
    --dest ${base_model_dir}/${model_app_name}/${model_subdir}


 
