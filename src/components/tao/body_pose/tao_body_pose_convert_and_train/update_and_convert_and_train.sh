set -x

# ################################################################
# 
# Updating dataset convert specs and creating tfrecords
#
# ################################################################

# map the output data location to the directory name used by the script
export ORIGINAL_SPECs_DIR=$1
export DOWNLOADED_DATA_DIR=$2/data
export DATASET_EXPORT_SPEC=$3
export UPDATED_SPECs_DIR=${10}/specs
export DATA_DIR=$4 # this is the output that's created by AzureML
export SPECFILE_REFERENCE_DATA_DIR=$5
export TRAIN_MODE=$6
export VAL_MODE=$7
export RELATIVE_TRAIN_MASK_DIRECTORY=$8
export RELATIVE_VAL_MASK_DIRECTORY=$9
export RELATIVE_TRAIN_DIRECTORY="train2017"
export RELATIVE_VAL_DIRECTORY="val2017"
export ANNOTATION_TRAIN_DIRECTORY="annotation_train_directory"
export ANNOTATION_VAL_DIRECTORY="annotation_val_directory"

mkdir -p $DATA_DIR/$RELATIVE_TRAIN_MASK_DIRECTORY
mkdir -p $DATA_DIR/$RELATIVE_VAL_MASK_DIRECTORY
mkdir -p $DATA_DIR/train2017
mkdir -p $DATA_DIR/val2017
mkdir -p $UPDATED_SPECs_DIR/data_pose_config

cp -r $DOWNLOADED_DATA_DIR/* $DATA_DIR

ls $DATA_DIR

bash ./update_specs.sh ${ORIGINAL_SPECs_DIR}/data_pose_config ${UPDATED_SPECs_DIR}/data_pose_config ${DATASET_EXPORT_SPEC} ${RELATIVE_TRAIN_MASK_DIRECTORY}:${DATA_DIR}/${RELATIVE_TRAIN_MASK_DIRECTORY},${RELATIVE_VAL_MASK_DIRECTORY}:${DATA_DIR}/${RELATIVE_VAL_MASK_DIRECTORY},${RELATIVE_TRAIN_DIRECTORY}:${DATA_DIR}/${RELATIVE_TRAIN_DIRECTORY},${RELATIVE_VAL_DIRECTORY}:${DATA_DIR}/${RELATIVE_VAL_DIRECTORY},${ANNOTATION_TRAIN_DIRECTORY}:${DATA_DIR}/annotations/person_keypoints_train2017.json,${ANNOTATION_VAL_DIRECTORY}:${DATA_DIR}/annotations/person_keypoints_val2017.json

ls ${UPDATED_SPECs_DIR} 

bash ./tao_body_pose_convert.sh ${UPDATED_SPECs_DIR}/data_pose_config ${DATASET_EXPORT_SPEC} \
    ${DATA_DIR}/${RELATIVE_TRAIN_MASK_DIRECTORY} ${DATA_DIR}/${RELATIVE_VAL_MASK_DIRECTORY} \
    ${TRAIN_MODE} ${VAL_MODE}

mv ${DATA_DIR}/${RELATIVE_TRAIN_MASK_DIRECTORY}/train-fold-000-of-001 ${DATA_DIR}
mv ${DATA_DIR}/${RELATIVE_VAL_MASK_DIRECTORY}/val-fold-000-of-001 ${DATA_DIR}


# ################################################################
# 
# Updating train specs and training
#
# ################################################################

export ORIGINAL_TRAIN_SPECs_DIR=${11}
export SPEC_FILE=${12}
export NUM_EPOCHS=${13}
export SPECFILE_REFERENCE_ROOT_DATA_DIR=${14}
export SPECFILE_REFERENCE_TRAINING_TF_RECORDS_DIR=${17}
export SPECFILE_REFERENCE_VAL_TF_RECORDS_DIR=/workspace/tao-experiments/bpnet/val/data/val-records
export KEY=${19}
export BASE_MODEL_DIR=${20}
export SPECFILE_REFERENCE_MODEL_DIR=${21}
export NUM_GPUS=${22}
export MODEL_NAME=${23}
export MODEL_SUBFOLDER=${24}
export TRAINED_MODEL_DIR=${25}
UPDATED_TRAIN_SPECs_DIR=${10}/specs
export GPU_INDEX=${26}
export USE_AMP=${27}
export LOG_FILE=${28}
export SPECFILE_MODEL_POSE_DIR=${29}
export SPECFILE_DATA_POSE_DIR=${30}
export CHECKPOINT_DIR="/workspace/tao-experiments/bpnet/models/exp_m1_unpruned"
export INFER_SPEC="/workspace/examples/bpnet/specs/infer_spec.yaml"

BASE_MODEL_DIR="${BASE_MODEL_DIR}/pretrained_model/bodyposenet_vtrainable_v1.0"

mkdir -p $TRAINED_MODEL_DIR/$MODEL_SUBFOLDER
mkdir -p $UPDATED_TRAIN_SPECs_DIR

ls -l $DOWNLOADED_DATA_DIR
ls -l $BASE_MODEL_DIR
ls -l $SPECFILE_MODEL_POSE_DIR
ls -l $SPECFILE_DATA_POSE_DIR
ls -l ${DATA_DIR}

mkdir -p $UPDATED_SPECs_DIR/model_pose_config
mv ${ORIGINAL_SPECs_DIR}/model_pose_config/bpnet_18joints.json $UPDATED_SPECs_DIR/model_pose_config
mv ${ORIGINAL_SPECs_DIR}/infer_spec.yaml $UPDATED_SPECs_DIR

bash ./update_train_specs.sh ${ORIGINAL_TRAIN_SPECs_DIR} ${UPDATED_TRAIN_SPECs_DIR} ${SPEC_FILE} 'num_epochs: [0-9]\+'%'num_epochs: '${NUM_EPOCHS},${SPECFILE_REFERENCE_ROOT_DATA_DIR}%${DATA_DIR},${SPECFILE_REFERENCE_TRAINING_TF_RECORDS_DIR}%${DATA_DIR},${SPECFILE_REFERENCE_VAL_TF_RECORDS_DIR}%${DATA_DIR},${SPECFILE_REFERENCE_MODEL_DIR}%${BASE_MODEL_DIR}/${MODEL_NAME},${SPECFILE_MODEL_POSE_DIR}%${UPDATED_SPECs_DIR}/model_pose_config/bpnet_18joints.json,${SPECFILE_DATA_POSE_DIR}%${UPDATED_SPECs_DIR}/data_pose_config/coco_spec.json,${CHECKPOINT_DIR}%${TRAINED_MODEL_DIR}/${MODEL_SUBFOLDER},${INFER_SPEC}%${UPDATED_SPECs_DIR}/infer_spec.yaml

bash ./tao_bpnet_train.sh ${UPDATED_TRAIN_SPECs_DIR} ${SPEC_FILE} ${TRAINED_MODEL_DIR} ${MODEL_SUBFOLDER} ${NUM_GPUS} ${KEY} ${GPU_INDEX} ${USE_AMP} 

if [[ "${LOG_FILE}" != "ND" ]]
then 
    LOG_FILE=$TRAINED_MODEL_DIR/$LOG_FILE
    python3 ./parse_info.py --logfile=$LOG_FILE --class_list=$CLASS_LIST --num_epochs=$NUM_EPOCHS
fi