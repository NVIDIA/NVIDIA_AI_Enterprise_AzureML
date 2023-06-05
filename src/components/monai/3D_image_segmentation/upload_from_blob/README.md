## Upload from blob
#### This component is used for MONAI image segmentation to load data from Registry Data Asset or directly from Blob Data Storage using 'azureml: //...' URL

### Arguments:
	  blob_file_location:
		type: uri_folder
		description: the input blob .tar file location
		mode: "ro_mount"
	  overwrite:
		type: boolean
		description: overwrire local data
		default: true
		optional: true

### Outputs:
	  image_data_folder:
		type: uri_folder
		description: the output folder where the uncompressed data will be written
		mode: "rw_mount"
		mode: "upload"  

### How to run it (an example is is in related samples):

	if use_registry:
		# Upload Command components from registry
		upload_component = ml_client_registry.components.get(name=upload_data_from_blob_name, label='latest')
	else:
		#Load components from source
		upload_component = load_component(source="../../../../../src/components/3D_image_segmentation/monai/upload_from_blob/upload_data_from_blob.yaml")
    
...

		#Load data pipeline step   
		load_step = upload_component(
			blob_file_location=pipeline_input_file,
		)
