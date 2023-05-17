
set -x

# map the output data location to the directory name used by the script

export MODEL_APP_NAME=$1
export MODEL_TYPE=$2
export MODEL_NAME=$3
export MODEL_SUBDIR=$4
export LOCAL_PROJECT_DIR=$5
export LOCAL_EXPERIMENT_DIR=$LOCAL_PROJECT_DIR/$MODEL_APP_NAME


# Installing NGC CLI on the local machine.
## Download and install
export CLI=ngccli_cat_linux.zip
mkdir -p $LOCAL_PROJECT_DIR/ngccli

# Remove any previously existing CLI installations
#rm -rf $LOCAL_PROJECT_DIR/ngccli/*
wget "https://ngc.nvidia.com/downloads/$CLI" -P $LOCAL_PROJECT_DIR/ngccli
unzip -u "$LOCAL_PROJECT_DIR/ngccli/$CLI" -d $LOCAL_PROJECT_DIR/ngccli/
rm $LOCAL_PROJECT_DIR/ngccli/*.zip 

export PATH=$PATH:$LOCAL_PROJECT_DIR/ngccli/ngc-cli

# List models available in the model registry.
ngc registry model list nvidia/tao/${MODEL_TYPE}:*


# Create the target destination to download the model.
mkdir -p $LOCAL_EXPERIMENT_DIR/${MODEL_SUBDIR}/


# Download the pretrained model from NGC
ngc registry model download-version nvidia/tao/${MODEL_TYPE}:${MODEL_NAME} \
    --dest $LOCAL_EXPERIMENT_DIR/$MODEL_SUBDIR

ls -rlt $LOCAL_EXPERIMENT_DIR/$MODEL_SUBDIR/
