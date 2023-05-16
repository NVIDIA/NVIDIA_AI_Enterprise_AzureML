set -x

# map the output data location to the directory name used by the script

export ORIGINAL_SPECs_DIR=$1
export SPECS_FILE=$2
export DATA_DIR=$3/data
export INPUT_SUBFOLDER=$4
export MODEL_DIR=$5
export SPECFILE_REFERENCE_MODEL_DIR=$6   
export KEY=$7
export OUTPUT_SUBFOLDER=$8
export NUMBER_OF_IMAGES=$9
export RESULTS_DIR=${10}
export UPDATED_SPECs_DIR=${10}/specs

mkdir $RESULTS_DIR
mkdir $RESULTS_DIR/$OUTPUT_SUBFOLDER
mkdir $UPDATED_SPECs_DIR


bash ./update_specs.sh ${ORIGINAL_SPECs_DIR} ${UPDATED_SPECs_DIR} ${SPECS_FILE} $SPECFILE_REFERENCE_MODEL_DIR:${MODEL_DIR}
bash ./tao_detectnet_v2_inference.sh ${UPDATED_SPECs_DIR} ${SPECS_FILE} ${RESULTS_DIR} ${OUTPUT_SUBFOLDER} ${DATA_DIR} ${INPUT_SUBFOLDER} ${KEY}
ls ${RESULTS_DIR}/${OUTPUT_SUBFOLDER}/images_annotated
python3 ./preview_images.py --image_dir ${RESULTS_DIR}/${OUTPUT_SUBFOLDER}/images_annotated --num_images ${NUMBER_OF_IMAGES}

