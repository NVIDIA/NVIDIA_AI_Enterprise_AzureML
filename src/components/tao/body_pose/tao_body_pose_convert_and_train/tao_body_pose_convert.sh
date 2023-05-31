#!/bin/bash  
export SPECS_DIR=$1
export DATASET_EXPORT_SPEC=$2
export TRAIN_MODE=$5
export VAL_MODE=$6
export TRAIN_TF_RECORDS_DIR=$3/$TRAIN_MODE # ends in either train or val -- this determines the name of the file like train-fold-000-of-001
export VAL_TF_RECORDS_DIR=$4/$VAL_MODE 

mkdir -p $TRAIN_TF_RECORDS_DIR
mkdir -p $VAL_TF_RECORDS_DIR

ls $SPECS_DIR

echo "bpnet dataset_convert -m $TRAIN_MODE -o $TRAIN_TF_RECORDS_DIR --generate_masks --dataset_spec $SPECS_DIR/$DATASET_EXPORT_SPEC"
bpnet dataset_convert -m $TRAIN_MODE -o $TRAIN_TF_RECORDS_DIR --generate_masks --dataset_spec $SPECS_DIR/$DATASET_EXPORT_SPEC
echo "bpnet dataset_convert -m $VAL_MODE -o $VAL_TF_RECORDS_DIR --generate_masks --dataset_spec $SPECS_DIR/$DATASET_EXPORT_SPEC"
bpnet dataset_convert -m $VAL_MODE -o $VAL_TF_RECORDS_DIR --generate_masks --dataset_spec $SPECS_DIR/$DATASET_EXPORT_SPEC