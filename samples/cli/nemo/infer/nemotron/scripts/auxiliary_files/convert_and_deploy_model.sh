#!/bin/bash
set -x

# map the output data location to the directory name used by the script

export AZUREML_MODEL_DIR=$1
export NUM_GPUS="$(nvidia-smi --query-gpu=name --format=csv,noheader | wc -l)"

export AZUREML_MODEL_SUBDIR=$(ls ${AZUREML_MODEL_DIR})
export AZUREML_MODEL=$(ls ${AZUREML_MODEL_DIR}/${AZUREML_MODEL_SUBDIR}/*.nemo)

ls -l ${AZUREML_MODEL}

AZUREML_MODEL_YML=$(sed "s#$AZUREML_MODEL_DIR/$AZUREML_MODEL_SUBDIR/##g" <<< "$AZUREML_MODEL")
AZUREML_MODEL_YML=$(sed "s#.nemo#.yml#g" <<< "$AZUREML_MODEL_YML")

cd /tmp

sed "s#nemo_path_placeholder#${AZUREML_MODEL}#g" /tmp/$AZUREML_MODEL_YML > /tmp/temp_${AZUREML_MODEL_YML}
sed "s#num_gpus_placeholder#${NUM_GPUS}#g" /tmp/temp_${AZUREML_MODEL_YML} > /tmp/actual_${AZUREML_MODEL_YML}

cat /tmp/actual_${AZUREML_MODEL_YML}

model_repo_generator llm --verbose --yaml_config_file=/tmp/actual_${AZUREML_MODEL_YML}

export CUSTOMIZATION_SOURCE="MMS"
export DATA_STORE_URL="gateway-api:9009"

nemollm_inference_ms --model nemotron --openai_port="9999" --nemo_port="9998" --num_gpus=${NUM_GPUS}




