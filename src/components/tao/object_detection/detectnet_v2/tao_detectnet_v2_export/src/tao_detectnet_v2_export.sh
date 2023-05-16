set -x

# map the output data location to the directory name used by the script
export SOURCE_MODEL_DIR=$1
export SOURCE_SUBFOLDER=$2
export SOURCE_MODEL_NAME=$3
export EXPORTED_MODEL_DIR=$4
export EXPORTED_SUBFOLDER=$5
export EXPORTED_MODEL_NAME=$6
export KEY=$7
export ENGINE_FILENAME=$8
export CAL_DATA_DIR=${9}
export CAL_DATA_FILENAME=${10}
export USE_IMAGE_CAL=${11}
export CAL_IMAGE_DIR=${12}
export CAL_CACHE_FILENAME=${13}
export EXPERIMENTS_SPECS_DIR=${14}
export EXPERIMENTS_SPECS_FILENAME=${15}
export DATA_TYPE=${16}
export STRICT_TYPE_CONSTRAINTS=${17}
export GEN_DS_CONFIG=${18}
export USE_VALIDATION_SET=${19}
export BATCHES=${20}
export BATCH_SIZE=${21}
export MAX_BATCH_SIZE=${22}
export MAX_WORKSPACE=${23}
export VERBOSE=${24}

mkdir ${EXPORTED_MODEL_DIR}
mkdir -p ${EXPORTED_MODEL_DIR}/${EXPORTED_SUBFOLDER}

ADDITIONAL_ARGS=""

if [[ "${ENGINE_FILENAME}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --engine_file ${EXPORTED_MODEL_DIR}/${EXPORTED_SUBFOLDER}/${ENGINE_FILENAME}"
fi

if [[ "${CAL_DATA_FILENAME}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --cal_data_file ${CAL_DATA_DIR}/${EXPORTED_SUBFOLDER}/${CAL_DATA_FILENAME}"
fi

if [[ "${USE_IMAGE_CAL}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --cal_image_dir ${CAL_IMAGE_DIR}"
fi

if [[ "${CAL_CACHE_FILENAME}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --cal_cache_file ${EXPORTED_MODEL_DIR}/${EXPORTED_SUBFOLDER}/${CAL_CACHE_FILENAME}"
fi

if [[ "${EXPERIMENTS_SPECS_FILENAME}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --experiment_spec ${EXPERIMENTS_SPECS_DIR}/${EXPERIMENTS_SPECS_FILENAME}"
fi

if [[ "${DATA_TYPE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --data_type ${DATA_TYPE}"
fi

if [[ "${STRICT_TYPE_CONSTRAINTS}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --strict_type_constraints"
fi

if [[ "${GEN_DS_CONFIG}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --gen_ds_config"
fi

if [[ "${USE_VALIDATION_SET}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --use_validation_set"
fi

if [[ "${BATCHES}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --batches ${BATCHES}"
fi

if [[ "${BATCH_SIZE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --batch_size ${BATCH_SIZE}"
fi

if [[ "${MAX_BATCH_SIZE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --max_batch_size ${MAX_BATCH_SIZE}"
fi

if [[ "${MAX_WORKSPACE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --max_workspace_size ${MAX_WORKSPACE}"
fi

if [[ "${VERBOSE}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --verbose"
fi

detectnet_v2 export -m ${SOURCE_MODEL_DIR}/${SOURCE_SUBFOLDER}/${SOURCE_MODEL_NAME} -o ${EXPORTED_MODEL_DIR}/${EXPORTED_SUBFOLDER}/${EXPORTED_MODEL_NAME} -k $KEY $ADDITIONAL_ARGS

ls -lh ${EXPORTED_MODEL_DIR}/${EXPORTED_SUBFOLDER}
