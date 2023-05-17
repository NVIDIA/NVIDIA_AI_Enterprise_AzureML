set -x

export SOURCE_DATA_DIR=$1"/data"
export IMAGE_SUB_DIRS=$2
export LABEL_FILES=$3
export OUTPUT_SUB_DIRS=$4
export IMAGE_HEIGHT=$5
export IMAGE_WIDTH=$6
export OUTPUT_DATA_DIR=$7"/data"

readarray -d , -t strarr1<<<"$IMAGE_SUB_DIRS"
readarray -d , -t strarr2<<<"$LABEL_FILES"
readarray -d , -t strarr3<<<"$OUTPUT_SUB_DIRS"

if [[ "${#strarr1[*]}" = "${#strarr2[*]}" ]]
then
    echo "Number of image subdirs and label files match." 
    echo "Continuining ..."
else
    echo "Number of image subdirs and label files do not match." 
    echo "Exiting ..."
    exit 1    
fi

if [[ "${#strarr1[*]}" = "${#strarr3[*]}" ]]
then
    echo "Number of image subdirs and output subdirs match." 
    echo "Continuining ..."
else
    echo "Number of image subdirs and output subdirs do not match." 
    echo "Exiting ..."
    exit 1    
fi

 
for (( n=0; n < ${#strarr1[*]}; n++ ))  
do
    export image_subdir=${strarr1[n]//[$'\t\r\n ']}
    export label_file=${strarr2[n]//[$'\t\r\n ']}
    export output_subdir=${strarr3[n]//[$'\t\r\n ']}
    python3 convert_wider_to_kitti.py --input_image_dir=$SOURCE_DATA_DIR/$image_subdir \
                                   --input_label_file=$SOURCE_DATA_DIR/$label_file \
                                   --output_dir=$OUTPUT_DATA_DIR/$output_subdir/ \
                                   --image_height=$IMAGE_HEIGHT --image_width=$IMAGE_WIDTH --grayscale
done

