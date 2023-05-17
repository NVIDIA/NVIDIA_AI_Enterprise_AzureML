set -x

function GET_SUBSTRING()
{
    INPUT=$1
    STR=$2
    OFF_VALUE=$3

    readarray -d $STR -t strarr<<<"$INPUT"
    n=${#strarr[*]}-$OFF_VALUE

    SUBSTRING=${strarr[n]}
}

export LOCAL_DATA_DIR=$1
export FILE_TYPE=$2
export URL=$3
export CHECKSUM=$4


GET_SUBSTRING $URL / 1
eval ZIPFILE=$SUBSTRING


# Download the dataset

if [ -d "$LOCAL_DATA_DIR" ];
then
    echo "$LOCAL_DATA_DIR directory exists."
else
	mkdir -p $LOCAL_DATA_DIR
fi


if [ ! -f $LOCAL_DATA_DIR/$ZIPFILE ]; then wget $URL -O $LOCAL_DATA_DIR/$ZIPFILE; else echo "${FILE_TYPE} archive already downloaded"; fi 

# Check the dataset is present
if [ ! -f $LOCAL_DATA_DIR/$ZIPFILE ]; then {
    echo "${FILE_TYPE} zip file not found, please download."; exit 1;
}
    else echo "Found ${FILE_TYPE} zip file.";fi


# This may take a while: verify integrity of zip files 
if [[ "$CHECKSUM" != "NA" ]]
then
    sha256sum $LOCAL_DATA_DIR/$ZIPFILE | cut -d ' ' -f 1 | grep -xq $CHECKSUM ; \
    if test $? -eq 0; then echo "${FILE_TYPE} Zip File OK"; else echo "${FILE_TYPE} Zip File corrupt, redownload!" && rm -f $LOCAL_DATA_DIR/${FILE_TYPE}; fi
fi


unzip -u $LOCAL_DATA_DIR/$ZIPFILE -d $LOCAL_DATA_DIR

ls $LOCAL_DATA_DIR