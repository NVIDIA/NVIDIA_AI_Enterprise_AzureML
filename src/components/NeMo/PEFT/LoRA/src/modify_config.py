import os
import argparse
import torch
#import shutil # not used
import pytorch_lightning as pl # need
from omegaconf import OmegaConf # need
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy # need
from pytorch_lightning.plugins.environments import TorchElasticEnvironment # need
# from nemo.collections.nlp.models.language_modeling.megatron_gpt_sft_model import MegatronGPTModel # probs not needed since they supply the model
# from nemo.collections.nlp.parts.nlp_overrides import NLPSaveRestoreConnector, PEFTSaveRestoreConnector # probs not needed until training
# from nemo.utils.exp_manager import exp_manager # probs not needed until training

parser = argparse.ArgumentParser()
parser.add_argument("--config-path",type=str, help= "Path to the config file")
parser.add_argument("--input-data-folder",type=str, help = "Directory containing processed data files")
parser.add_argument("--train-file",type=str, help = "name of the train jsonl file")
parser.add_argument("--val-file",type=str, help = "name of the validation jsonl file")
parser.add_argument("--model",type=str, help= "Path to the model")
parser.add_argument("--output-dir", type=str, help= "Directory to store the outputs of training")
args = parser.parse_args()

# model config setup
config = OmegaConf.load(f"{args.config_path}")
config.model.data.train_ds.file_names = [f"{args.input_data_folder}/{args.train_file}"]
config.model.data.validation_ds.file_names = [f"{args.input_data_folder}/{args.val_file}"]
config.model.data.validation_ds.names=["eval"]

# peft config
config.model.peft.peft_scheme="lora"  # we can also set this to adapter or ptuning or ia3

# define the prompt format
config.model.data.train_ds.prompt_template ="{input} {output}"

# setting the pretrained GPT model
# print(MegatronGPTModel.list_available_models())
config.model.restore_from_path = f"{args.model}"

# saving intermediate training logs and checkpoints
config.exp_manager.exp_dir=f"{args.output_dir}/peft_lora"
config.exp_manager.explicit_log_dir="training_info"
config.trainer.max_steps=100
config.model.micro_batch_size=1
config.model.global_batch_size=4
config.trainer.val_check_interval=50
config.model.data.train_ds.num_workers=0  # 0 is recommended which just uses the main thread to process training examples
config.model.data.validation_ds.num_workers=0 # 0 is recommended which just uses the main thread to process the validation examples

# Final model config
print(OmegaConf.to_yaml(config.model))

### Building the PyTorch Lightining Trainer ###
# check if we have GPU available and uses it
accelerator = 'gpu' if torch.cuda.is_available() else 'cpu'
config.trainer.accelerator = accelerator
config.trainer.devices = 1
config.trainer.max_epochs = 9999
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

# Final trainer config
print("Trainer config - \n")
print(OmegaConf.to_yaml(config.trainer)) 

### Setting up a NeMo Experiment ###

# Set name of the experiment 
config.name = 'lora_tuning'
config.exp_manager.resume_if_exists = False

# TODO: I believe this is all training and not part of building the config
# # Init the experiment manager and view the exp_dir
# exp_dir = exp_manager(trainer, config.get("exp_manager", None))
# exp_dir = str(exp_dir)
# print("exp dir:",exp_dir)


# # First P-Tuning session
# model = MegatronGPTPromptLearningModel(cfg=config.model, trainer=trainer)
# trainer.fit(model)

# # Copying the model checkpoint to the output directory at the end of training
# source_folder = exp_dir
# destination_folder = args.output_dir
# shutil.copytree(source_folder, destination_folder, dirs_exist_ok = True)

# We need to save the config file as well to the output folder. This will be used with inferencing
OmegaConf.save(config=config, f=f"{args.output_dir}/modified_config.yaml")