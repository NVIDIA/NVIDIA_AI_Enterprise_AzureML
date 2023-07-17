import argparse

import pytorch_lightning as pl
from omegaconf import OmegaConf
from pytorch_lightning.plugins.environments import TorchElasticEnvironment
from nemo.utils.exp_manager import exp_manager
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy
    
parser = argparse.ArgumentParser()
parser.add_argument("--source_config_file", type=str)
parser.add_argument("--dest_config_file", type=str)
args = parser.parse_args()

config = OmegaConf.load(f"{args.source_config_file}")

print(OmegaConf.to_yaml(config.model))

# Setting up a NeMo Experiment
# Set name of the experiment 
config.name = 'p_tuning'
config.exp_manager.resume_if_exists = False
strategy = NLPDDPStrategy(find_unused_parameters=False, no_ddp_communication_hook=True)
plugins = [TorchElasticEnvironment()]
trainer = pl.Trainer(plugins= plugins, strategy=strategy, **config.trainer)
# Init the experiment manager and view the exp_dir
exp_dir = exp_manager(trainer, config.get("exp_manager", None))
exp_dir = str(exp_dir)
print("exp dir:",exp_dir)

OmegaConf.save(config=config, f=args.dest_config_file)

