## Train Segmentation
#### This component is used for MONAI image segmentation to train segmentation model

### Arguments:
	  input_data:
		type: uri_folder
		description: the input folder
		mode: "ro_mount"
	  best_model_name:
		type: string
		description: best model name
	  max_epochs:
		type: integer
		description: total number of epochs for local training
		default: 2
		optional: true    

### Outputs:
	  model:
		type: uri_folder
		description: the output checkpoint

### How to run it (an example is is in related samples):

	if use_registry:
		# Upload Command components from registry
		train_component = ml_client_registry.components.get(name=train_segmentation_name, label='latest')
	else:
		#Load components from source
		train_component = load_component(source="../../../../../src/components/3D_image_segmentation/monai/train_segmentation/train_segmentation.yaml")
    
...

Train pipeline step:

        train_step = train_component(
            input_data=load_step.outputs.image_data_folder, best_model_name="model_from_notebook", max_epochs = 2
        )
        train_step.distribution.process_count_per_instance=4
        train_step.resources = {'instance_count' : 1, 'shm_size':'300g'}
        train_step.environment_variables = {'AZUREML_ARTIFACTS_DEFAULT_TIMEOUT' : '1000'}
        train_step.compute_target =low_pri_compute

        return {
            "model" : train_step.outputs.model,
        }
