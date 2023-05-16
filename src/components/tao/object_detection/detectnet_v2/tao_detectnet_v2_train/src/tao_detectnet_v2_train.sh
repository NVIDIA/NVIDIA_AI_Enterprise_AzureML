set -x

# map the output data location to the directory name used by the script

export UPDATED_SPECs_DIR=$1
export SPECS_FILE=$2
export TRAINED_MODEL_DIR=$3
export MODEL_SUBFOLDER=$4
export NUM_GPUS=$5
export KEY=$6
export NAME_STRING_FOR_THE_MODEL=$7
export GPU_INDEX=${8}
export USE_AMP=${9}
export LOG_FILE=${10}

export ADDITIONAL_ARGS=""

if [[ "${GPU_INDEX}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --gpu_index $GPU_INDEX"
fi

if [[ "${USE_AMP}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --use_amp"
fi

if [[ "${LOG_FILE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --log_file $TRAINED_MODEL_DIR/$LOG_FILE"
fi

detectnet_v2 train -e ${UPDATED_SPECs_DIR}/${SPECS_FILE} -r ${TRAINED_MODEL_DIR}/${MODEL_SUBFOLDER} -k $KEY -n ${NAME_STRING_FOR_THE_MODEL} --gpus ${NUM_GPUS} ${ADDITIONAL_ARGS}

ls ${UPDATED_SPECs_DIR}
ls ${TRAINED_MODEL_DIR}
ls -lh ${TRAINED_MODEL_DIR}/${MODEL_SUBFOLDER}/weights
