set -x

# map the output data location to the directory name used by the script

export MODELS_MOUNTING_DIR=$1
echo $MODELS_MOUNTING_DIR

for configfile in $(find $MODELS_MOUNTING_DIR -name '*.pbtxt');
do	
    sed -i "s#/triton-models#${MODELS_MOUNTING_DIR}#g" $configfile
    cat $configfile
done;

