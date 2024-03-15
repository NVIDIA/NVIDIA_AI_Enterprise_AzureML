set -x

# map the output data location to the directory name used by the script

export AZUREML_MODEL_DIR=$1
echo $AZUREML_MODEL_DIR

mkdir /model-store
cp -r ${AZUREML_MODEL_DIR}/$(ls ${AZUREML_MODEL_DIR})/* /model-store/

ls -l /model-store/

nemollm_inference_ms --model llama-2-7b --openai_port="9999" --nemo_port="9998" --num_gpus=1
