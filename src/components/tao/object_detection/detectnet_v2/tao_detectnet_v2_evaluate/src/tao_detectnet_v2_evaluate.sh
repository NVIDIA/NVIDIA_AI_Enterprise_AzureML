set -x

# map the output data location to the directory name used by the script

export UPDATED_SPECs_DIR=$1
export SPECS_FILE=$2
export TARGET_MODEL_DIR=$3
export MODEL_SUBFOLDER=$4
export KEY=$5
export MODEL_NAME=$6
export FRAMEWORK=${7}
export USE_TRAINING_SET=${8} 
export GPU_INDEX=${9}

ADDITIONAL_ARGS=""

pip install h5py==2.10.0 

if [[ "${FRAMEWORK}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS -f $FRAMEWORK"
fi

if [[ "${USE_TRAINING_SET}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --use_training_set"
fi

if [[ "${GPU_INDEX}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --gpu_index ${GPU_INDEX}"
fi

detectnet_v2 evaluate -e ${UPDATED_SPECs_DIR}/${SPECS_FILE} -m ${TARGET_MODEL_DIR}/${MODEL_SUBFOLDER}/${MODEL_NAME} -k $KEY $ADDITIONAL_ARGS


