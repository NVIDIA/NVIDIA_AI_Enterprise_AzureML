export inf_env=../../../../src/Environments/inference/
export train_env=../../../../src/Environments/train/
export train_seg_comp=../../../../src/Components/monai_train_segmentation/
export upload_blob_comp=../../../../src/Components/monai_upload_from_blob/
export cpu_cluster=../../../../src/Compunes/cpu_cluster_Standard_D13_v2/
export gpu_cluster=../../../../src/Computes/gpu_cluster_Standard_NC96ads_A100_v4/

export running_pipeline_file=pipelines/${nvidia_product}/${container}/${product_subfolder}/pipeline_run.yml

cp $pipeline_file $running_pipeline_file

sed -i "s/<gpu-cluster>/${compute_name}/g" $running_pipeline_file
sed -i "s/<registry_name>/${registry_name}/g" $running_pipeline_file
sed -i "s/<num_epochs>/${num_epochs}/g" $running_pipeline_file

cat $running_pipeline_file

echo "az ml job create --file $running_pipeline_file"

az ml job create --file $running_pipeline_file
