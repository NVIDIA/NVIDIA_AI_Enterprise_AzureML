#!/bin/bash

source scripts/config_files/endpoint_config.sh

if [ "$#" -ne 2 ]; then
    echo "infer.sh requires 2 arguments"
exit 2
fi

input=$1
output=$2

cd tao-toolkit-triton-apps
python3 -m venv virtualenv
source virtualenv/bin/activate
export PYTHONPATH=$(pwd)/tao_triton:${PYTHONPATH}
python tao_triton/python/entrypoints/tao_client_aml.py $input -m detectnet_tao -x 1 -b 8 --mode DetectNet_v2 --class_list car,cyclist,pedestrian -i https -u $endpoint_url -t $endpoint_token --async --output_path $output --postprocessing_config tao_triton/python/clustering_specs/clustering_config_detectnet.prototxt 