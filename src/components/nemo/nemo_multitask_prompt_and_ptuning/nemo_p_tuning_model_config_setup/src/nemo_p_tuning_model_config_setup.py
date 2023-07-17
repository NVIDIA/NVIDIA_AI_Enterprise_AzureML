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

import argparse, os
from omegaconf import OmegaConf
from nemo.collections.nlp.modules.common import VirtualPromptStyle
from nemo.collections.nlp.models.language_modeling.megatron_gpt_model import MegatronGPTModel

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--source_config_file", type=str)
    parser.add_argument("--model_file", type=str)
    parser.add_argument("--train_file", type=str)
    parser.add_argument("--val_file", type=str)
    parser.add_argument("--dest_config_file", type=str)
    parser.add_argument("--model_micro_batch_size", type=str)
    parser.add_argument("--model_task_templates", type=str)
    parser.add_argument("--model_new_tasks", type=str)
    
    args = parser.parse_args()
    print(args.source_config_file)
    os.path.isfile(args.source_config_file)

    config = OmegaConf.load(args.source_config_file)
    config.model.data.train_ds = [args.train_file]
    config.model.data.validation_ds = [args.val_file]

    # Define the prompt template
    if args.model_task_templates != "ND":
        config.model.task_templates = list(eval(args.model_task_templates))

    #set the new tasks
    config.model.existing_tasks = []
    if args.model_new_tasks != "ND":
        config.model.new_tasks = [args.model_new_tasks] 

    print(MegatronGPTModel.list_available_models())

    config.model.language_model_path = f"{args.model_file}"
    print(config.model.language_model_path)

    config.exp_manager.checkpoint_callback_params.save_nemo_on_train_end= True
    config.exp_manager.checkpoint_callback_params.always_save_nemo= True
    config.exp_manager.checkpoint_callback_params.save_best_model= True
    config.model.virtual_prompt_style = VirtualPromptStyle.P_TUNING
    config.model.p_tuning.dropout = 0.0
    config.model.p_tuning.num_layers = 2
    config.model.global_batch_size = 2

    if args.model_micro_batch_size != "ND":
        config.model.micro_batch_size = int(args.model_micro_batch_size)
    


    #Final model config
    print(OmegaConf.to_yaml(config.model))
    OmegaConf.save(config=config, f=args.dest_config_file)

if __name__ == "__main__":
    main()
