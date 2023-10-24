set -x

# map the output data location to the directory name used by the script

export AZUREML_MODEL_DIR=$1
echo $AZUREML_MODEL_DIR

bash /opt/aux/replace_model_mounting_dir.sh $AZUREML_MODEL_DIR
/opt/tritonserver/bin/tritonserver --model-store=${AZUREML_MODEL_DIR}/$(ls ${AZUREML_MODEL_DIR})

