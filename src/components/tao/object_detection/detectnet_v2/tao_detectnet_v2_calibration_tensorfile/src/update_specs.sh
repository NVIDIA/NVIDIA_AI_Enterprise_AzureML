set -x

# map the output data location to the directory name used by the script

export ORIGINAL_SPECs_DIR=$1
export UPDATED_SPECs_DIR=$2
export FILE_TO_COPY=$3
export PATERNS_TO_SUBSTITUTE=$4

for entry in "$ORIGINAL_SPECs_DIR"
do
  readarray -d , -t strarr<<<"$entry"
  n=${#strarr[*]}-1
  if [ "${strarr[n]}"=$FILE_TO_COPY ]
  then
    cp $ORIGINAL_SPECs_DIR/$FILE_TO_COPY $UPDATED_SPECs_DIR/$FILE_TO_COPY
    readarray -d , -t strarr2<<<"$PATERNS_TO_SUBSTITUTE"
    for (( n=0; n < ${#strarr2[*]}; n++ ))  
    do
      pair="${strarr2[n]}"
      readarray -d : -t strarr3<<<"$pair"
      param1=${strarr3[0]}
      param2=`echo ${strarr3[1]} | sed -e 's/^[[:space:]]*//'`
      echo sed -i '"'s%${param1}%${param2}%g'"' $UPDATED_SPECs_DIR/$FILE_TO_COPY
      sed -i "s%${param1}%${param2}%g" $UPDATED_SPECs_DIR/$FILE_TO_COPY
    done
    cat $UPDATED_SPECs_DIR/$FILE_TO_COPY
    ls $UPDATED_SPECs_DIR
  fi  
done
