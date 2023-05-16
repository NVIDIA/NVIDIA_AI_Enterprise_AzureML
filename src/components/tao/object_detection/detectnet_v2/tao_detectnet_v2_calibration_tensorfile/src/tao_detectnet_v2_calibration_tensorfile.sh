set -x

# map the output data location to the directory name used by the script

export UPDATED_SPECs_DIR=$1
export SPECS_FILE=$2
export OUTPUT_SUBFOLDER=$3
export OUTPUT_FILENAME=$4
export OUTPUT_DIR=$5
export MAX_BATCHES=$6
export USE_VALIDATION_SET=$7

ADDITIONAL_ARGS=""

if [[ "${USE_VALIDATION_SET}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --use_validation_set"
fi

detectnet_v2 calibration_tensorfile -e ${UPDATED_SPECs_DIR}/${SPECS_FILE} -m ${MAX_BATCHES} -o ${OUTPUT_DIR}/${OUTPUT_SUBFOLDER}/${OUTPUT_FILENAME} $ADDITIONAL_ARGS
