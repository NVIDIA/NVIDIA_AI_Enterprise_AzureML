set -x

# map the output data location to the directory name used by the script

export UPDATED_SPECs_DIR=$1
export SPECS_FILE=$2
export RESULTS_DIR=$3
export OUTPUT_SUBFOLDER=$4
export DATA_DIR=$5
export INPUT_SUBFOLDER=$6
export KEY=$7

detectnet_v2 inference -e ${UPDATED_SPECs_DIR}/${SPECS_FILE} -o ${RESULTS_DIR}/${OUTPUT_SUBFOLDER} -i ${DATA_DIR}/$INPUT_SUBFOLDER -k $KEY

ls ${UPDATED_SPECs_DIR}
ls ${RESULTS_DIR}/${OUTPUT_SUBFOLDER} 
