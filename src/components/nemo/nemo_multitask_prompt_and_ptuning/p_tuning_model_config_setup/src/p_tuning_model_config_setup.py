# Copyright (c) 2022, NVIDIA CORPORATION.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import json

from tqdm import tqdm
from omegaconf import OmegaConf

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source_config_file", type=str)
    parser.add_argument("--model-file", type=str)
    parser.add_argument("--train-file", type=str)
    parser.add_argument("--val-file", type=str)
    parser.add_argument("--dest_config_file", type=str)
    

    args = parser.parse_args()
    config = OmegaConf.load(args.source_config_file)

    config.model.data.train_ds = [args.train_file]
    config.model.data.validation_ds = [args.val_file]

    OmegaConf.save(config, args.dest_config_file)


if __name__ == "__main__":
    main()
