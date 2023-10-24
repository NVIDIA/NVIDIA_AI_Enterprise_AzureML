#!/bin/bash

echo  ${PWD}
ls ${PWD}/scripts/models/
docker run --gpus all -it -v ${PWD}/scripts/models/GPT-2B:/opt/checkpoints/ -w /opt/NeMo nvcr.io/ea-bignlp/beta-inf-prerelease/infer:23.08.v7