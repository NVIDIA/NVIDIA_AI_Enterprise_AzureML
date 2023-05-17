set -x

export URLS=$1
export FILE_TYPES=$2
export CHECKSUMS=$3
export LOCAL_PROJECT_DIR=$4
export LOCAL_DATA_DIR=${LOCAL_PROJECT_DIR}"/data"

readarray -d , -t strarr1<<<"$URLS"
readarray -d , -t strarr2<<<"$FILE_TYPES"

if [[ "${#strarr1[*]}" = "${#strarr2[*]}" ]]
then
    echo "urls and file types number match." 
    echo "Continuining ..."
else
    echo "urls and file types number do not match." 
    echo "Exiting ..."
    exit 1    
fi

if [[ "${CHECKSUMS}" != "NA" ]]
then
    readarray -d , -t strarr3<<<"$CHECKSUMS"

    if [[ "${#strarr1[*]}" = "${#strarr3[*]}" ]]
    then
        echo "urls and checksums number match"
        echo "Continuining ..."    
        for (( n=0; n < ${#strarr1[*]}; n++ ))  
        do
            export type=${strarr2[n]//[$'\t\r\n ']}
            export url=${strarr1[n]//[$'\t\r\n ']}
            export checksum=${strarr3[n]//[$'\t\r\n ']}
            echo "bash download_data.sh $LOCAL_DATA_DIR ${type} ${url} ${checksum}"
            bash download_data.sh $LOCAL_DATA_DIR ${type} ${url} ${checksum}
        done
    else
        echo "Error urls and checksums number do not match"
        echo "Exiting ..."
        exit 1
    fi
else
    for (( n=0; n < ${#strarr1[*]}; n++ ))  
    do
        export type=${strarr2[n]//[$'\t\r\n ']}
        export url=${strarr1[n]//[$'\t\r\n ']}    
        echo "bash download_data.sh $LOCAL_DATA_DIR ${type} ${url} NA"
        bash download_data.sh $LOCAL_DATA_DIR ${type} ${url} "NA"
    done
fi
