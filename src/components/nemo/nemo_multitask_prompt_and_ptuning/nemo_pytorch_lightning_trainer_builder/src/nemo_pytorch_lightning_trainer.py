import os
import argparse
import torch
import pytorch_lightning as pl
from omegaconf import OmegaConf
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy
from pytorch_lightning.plugins.environments import TorchElasticEnvironment

    
parser = argparse.ArgumentParser()
parser.add_argument("--source_config_file", type=str)
parser.add_argument("--dest_config_file", type=str)
args = parser.parse_args()

config = OmegaConf.load(f"{args.source_config_file}")

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

OmegaConf.save(config=config, f=args.dest_config_file)

