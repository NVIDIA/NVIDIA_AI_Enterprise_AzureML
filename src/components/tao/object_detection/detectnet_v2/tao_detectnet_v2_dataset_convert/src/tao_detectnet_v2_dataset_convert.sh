#!/bin/bash  
export SPECS_DIR=$1
export DATASET_EXPORT_SPEC=$2
export TF_RECORDS_DIR=$3/tfrecords
export DATA_FILENAME=$4
export VALIDATION_FOLD=$5

mkdir -p $TF_RECORDS_DIR
rm -rf $TF_RECORDS_DIR/*

ls $SPECS_DIR
ls $TF_RECORDS_DIR

export ADDITIONAL_ARGS=""

if [[ "${VALIDATION_FOLD}" != "ND" ]]
then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS -f ${VALIDATION_FOLD}"
fi

detectnet_v2 dataset_convert -d $SPECS_DIR/$DATASET_EXPORT_SPEC -o $TF_RECORDS_DIR/$DATA_FILENAME $ADDITIONAL_ARGS
