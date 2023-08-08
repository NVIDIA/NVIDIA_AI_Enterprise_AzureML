import os
import argparse
import torch
import shutil
import pytorch_lightning as pl
from omegaconf import OmegaConf
from nemo.collections.nlp.models.language_modeling.megatron_gpt_model import MegatronGPTModel
from nemo.collections.nlp.modules.common import VirtualPromptStyle
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy
from pytorch_lightning.plugins.environments import TorchElasticEnvironment
from nemo.collections.nlp.models.language_modeling.megatron_gpt_prompt_learning_model import MegatronGPTPromptLearningModel
from nemo.utils.exp_manager import exp_manager

parser = argparse.ArgumentParser()
parser.add_argument("--config-path",type=str, help= "Path to the config file")
parser.add_argument("--processed-data-dir",type=str, help = "Directory containing processed data files")
parser.add_argument("--model",type=str, help= "Path to the model")
parser.add_argument("--output-dir", type=str, help= "Directory to store the outputs of training")
args = parser.parse_args()

config = OmegaConf.load(f"{args.config_path}")
config.model.data.train_ds = [f"{args.processed_data_dir}/squad_short_train.jsonl"]
config.model.data.validation_ds = [f"{args.processed_data_dir}/squad_short_val.jsonl"]

# Define the prompt template
config.model.task_templates = [   
    {
        "taskname": "squad",
        "prompt_template": "<|VIRTUAL_PROMPT_0|> Context: {context}\n\nQuestion: {question}\n\nAnswer:{answer}",
        "total_virtual_tokens": 15,
        "virtual_token_splits": [15],
        "truncate_field": "context",
        "answer_only_loss": True,
        "answer_field": "answer",
    },
]

#set the new tasks
config.model.existing_tasks = []
config.model.new_tasks = ["squad"] 

print(MegatronGPTModel.list_available_models())

# create the temp directory
source_folder = args.model
model_source_folder = "/tmp/nemo_source_model"
os.mkdir(model_source_folder)
shutil.copytree(source_folder, model_source_folder, dirs_exist_ok = True)


config.model.language_model_path = f"{model_source_folder}"
print(config.model.language_model_path)

print("config.model.language_model_path {0}".format(config.model.language_model_path))
os.system("ls {0}".format(config.model.language_model_path))

config.exp_manager.checkpoint_callback_params.save_nemo_on_train_end= True
config.exp_manager.checkpoint_callback_params.always_save_nemo= True
config.exp_manager.checkpoint_callback_params.save_best_model= True
config.model.virtual_prompt_style = VirtualPromptStyle.P_TUNING
config.model.p_tuning.dropout = 0.0
config.model.p_tuning.num_layers = 2
config.model.global_batch_size = 2
config.model.micro_batch_size = 1

#Final model config
print(OmegaConf.to_yaml(config.model))

### Building the PyTorch Lightining Trainer


# let's modify some trainer configs
# check if we have GPU available and uses it
accelerator = 'gpu' if torch.cuda.is_available() else 'cpu'
config.trainer.accelerator = accelerator
config.trainer.devices = 1
config.trainer.max_epochs = 4
config.trainer.val_check_interval = 1.0

# for PyTorch Native AMP set precision=16
config.trainer.precision = 16 if torch.cuda.is_available() else 32

# setup cluster environment parameters"
# use torch elastic cluster environment so `create_process_externally` is True
# the launcher is set to None. It will not try to spawn new processes.
# It won't create the misconfiguration error because of the `interactive session`
os.environ["LOCAL_RANK"] = '0'
os.environ["RANK"] = '0'
os.environ["WORLD_SIZE"] = '1'

strategy = NLPDDPStrategy(find_unused_parameters=False, no_ddp_communication_hook=True)
plugins = [TorchElasticEnvironment()]
trainer = pl.Trainer(plugins= plugins, strategy=strategy, **config.trainer)

print("Trainer config - \n")
print(OmegaConf.to_yaml(config.trainer))


# Setting up a NeMo Experiment
# Set name of the experiment 
config.name = 'p_tuning'
config.exp_manager.resume_if_exists = False

# Init the experiment manager and view the exp_dir
exp_dir = exp_manager(trainer, config.get("exp_manager", None))
exp_dir = str(exp_dir)
print("exp dir:",exp_dir)

# Set some of the learning parameters
config.model.optim.lr = 1e-4
config.model.precision = config.trainer.precision



# First P-Tuning session
model = MegatronGPTPromptLearningModel(cfg=config.model, trainer=trainer)
trainer.fit(model)

# Copying the model checkpoint to the output directory at the end of training
source_folder = exp_dir
destination_folder = args.output_dir
shutil.copytree(source_folder, destination_folder, dirs_exist_ok = True)

# We need to save the config file as well to the output folder. This will be used with inferencing
OmegaConf.save(config=config, f=f"{args.output_dir}/modified_config.yaml")