import os
import argparse
import wget
import shutil
import torch
import torch.multiprocessing as mp
import pytorch_lightning as pl
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy
from pytorch_lightning.plugins.environments import TorchElasticEnvironment
from megatron.core import parallel_state
from omegaconf import OmegaConf
from omegaconf.omegaconf import open_dict
from pytorch_lightning.trainer.trainer import Trainer

from nemo.collections.nlp.models.language_modeling.megatron_gpt_model import MegatronGPTModel
from nemo.collections.nlp.models.language_modeling.megatron_gpt_prompt_learning_model import (
    MegatronGPTPromptLearningModel,
)
from nemo.collections.nlp.modules.common.transformer.text_generation import LengthParam, SamplingParam
from nemo.collections.nlp.parts.nlp_overrides import NLPDDPStrategy, NLPSaveRestoreConnector
from nemo.core.config import hydra_runner

#inputs expected by the component
parser = argparse.ArgumentParser()
parser.add_argument("--trained-result-dir", type=str, help = "Directory containing outputs of traing (model, modified configs, etc.)")
parser.add_argument("--model",type=str, help= "Path to the Frozen GPT model")
args = parser.parse_args()

# create the temp directory
source_folder = args.trained_result_dir
destination_folder = "/tmp/nemo_experiment"
os.mkdir(destination_folder)
shutil.copytree(source_folder, destination_folder, dirs_exist_ok = True)

#move the ptuning.nemo from checkpoints folder to one level up
shutil.move("/tmp/nemo_experiment/checkpoints/p_tuning.nemo", "/tmp/nemo_experiment/p_tuning.nemo")

#copy the frozen GPT model as well to this folder
shutil.copy2(args.model,"/tmp/nemo_experiment/megatron_gpt_345m.nemo")

# Get the config file
os.chdir(destination_folder)
CONFIG_DIR = "."
BRANCH= "main"
wget.download(f'https://raw.githubusercontent.com/NVIDIA/NeMo/main/examples/nlp/language_modeling/conf/megatron_gpt_prompt_learning_inference.yaml', CONFIG_DIR)
CONFIG_FILE = os.path.join(CONFIG_DIR, "megatron_gpt_prompt_learning_inference.yaml")
cfg = OmegaConf.load(CONFIG_FILE)

#Define trainer related variables
os.environ["LOCAL_RANK"] = '0'
os.environ["RANK"] = '0'
os.environ["WORLD_SIZE"] = '1'
strategy = NLPDDPStrategy(find_unused_parameters=False, no_ddp_communication_hook=True)
plugins = [TorchElasticEnvironment()]
trainer = pl.Trainer(plugins= plugins, strategy=strategy, **cfg.trainer)

cfg.gpt_model_file='/tmp/nemo_experiment/megatron_gpt_345m.nemo'
cfg.virtual_prompt_model_file='/tmp/nemo_experiment/p_tuning.nemo'

if (
    cfg.tensor_model_parallel_size < 0
    or cfg.pipeline_model_parallel_size < 0
    or cfg.get('pipeline_model_parallel_split_rank', -1) < 0
):
    save_restore_connector = NLPSaveRestoreConnector()
    if os.path.isdir(cfg.gpt_model_file):
        save_restore_connector.model_extracted_dir = cfg.gpt_model_file
    model_config = MegatronGPTModel.restore_from(
        restore_path=cfg.gpt_model_file,
        trainer=trainer,
        return_config=True,
        save_restore_connector=save_restore_connector,
    )

    with open_dict(cfg):
        cfg.tensor_model_parallel_size = model_config.get('tensor_model_parallel_size', 1)
        cfg.pipeline_model_parallel_size = model_config.get('pipeline_model_parallel_size', 1)
        cfg.pipeline_model_parallel_split_rank = model_config.get('pipeline_model_parallel_split_rank', 0)

assert (
        cfg.trainer.devices * cfg.trainer.num_nodes
        == cfg.tensor_model_parallel_size * cfg.pipeline_model_parallel_size
    ), "devices * num_nodes should equal tensor_model_parallel_size * pipeline_model_parallel_size"

# Update frozen GPT model path if it is given in case it has changed
prompt_learning_cfg = MegatronGPTPromptLearningModel.restore_from(
    cfg.virtual_prompt_model_file, trainer=trainer, return_config=True,
)
if cfg.get("gpt_model_file"):
    with open_dict(prompt_learning_cfg):
        prompt_learning_cfg.language_model_path = cfg.gpt_model_file
        prompt_learning_cfg.sequence_parallel = False
        prompt_learning_cfg.activations_checkpoint_method = None
        prompt_learning_cfg.activations_checkpoint_granularity = None
        prompt_learning_cfg.activations_checkpoint_num_layers = None

# Load prompt tuned model, virtual_prompt_model_file must be provided in config
# Now load prompt learning model with frozen gpt model base
model = MegatronGPTPromptLearningModel.restore_from(
    restore_path=cfg.virtual_prompt_model_file, trainer=trainer, override_config_path=prompt_learning_cfg,
)
model.freeze()

test_examples = [
    {"taskname": "squad", "context": "The build was released for download later in the day in standard 32-bit and 64-bit versions, plus a special 64-bit version which included SDKs and developer tools (Visual Studio Express and Expression Blend) for developing Metro-style apps. The Windows Store was announced during the presentation, but was not available in this build. According to Microsoft, there were about 535,000 downloads of the developer preview within the first 12 hours of its release. Originally set to expire on March 11, 2012, in February 2012 the Developer Preview's expiry date was changed to January 15, 2013.", "question": "When was the Developer preview initially intended to expire?"},
    {"taskname": "squad", "context": "The structures of most federal governments incorporate mechanisms to protect the rights of component states. One method, known as 'intrastate federalism', is to directly represent the governments of component states in federal political institutions. Where a federation has a bicameral legislature the upper house is often used to represent the component states while the lower house represents the people of the nation as a whole. A federal upper house may be based on a special scheme of apportionment, as is the case in the senates of the United States and Australia, where each state is represented by an equal number of senators irrespective of the size of its population.", "question": "What is a bicameral legislature?"},
    {"taskname": "squad", "context": "Imported mystery religions, which offered initiates salvation in the afterlife, were a matter of personal choice for an individual, practiced in addition to carrying on one's family rites and participating in public religion. The mysteries, however, involved exclusive oaths and secrecy, conditions that conservative Romans viewed with suspicion as characteristic of \"magic\", conspiratorial (coniuratio), or subversive activity. Sporadic and sometimes brutal attempts were made to suppress religionists who seemed to threaten traditional morality and unity, as with the senate's efforts to restrict the Bacchanals in 186 BC.", "question": "What was the practice of religion to the Romans?"}
]

response = model.generate(inputs=test_examples, length_params=None)

print('The prediction results of some sample queries with the trained model:')
for result in response['sentences']:
    print(result)
    print("-" * 30)

#print the contents in this temp directory
dir_list = os.listdir(destination_folder)
print(dir_list)










'''
#Get modified config
#CONFIG_FILE = f"{args.trained_result_dir}/modified_config.yaml"

print(CONFIG_FILE)



# Get p-tuned model config
cfg.virtual_prompt_model_file=f"{args.trained_result_dir}/checkpoints/p_tuning.nemo"


wget.download(f"https://api.ngc.nvidia.com/v2/models/nvidia/nemo/megatron_gpt_345m/versions/1/files/megatron_gpt_345m.nemo",destination_folder)



prompt_learning_cfg = MegatronGPTPromptLearningModel.restore_from(
        cfg.virtual_prompt_model_file, trainer=trainer, return_config=True,
)
print("prompt_learning_cfg:", prompt_learning_cfg)

print("virtual_prompt_model_file: ",cfg.virtual_prompt_model_file)


# Load prompt learning model with frozen gpt model base
model = MegatronGPTPromptLearningModel.restore_from(
        restore_path=cfg.virtual_prompt_model_file, trainer=trainer, override_config_path=prompt_learning_cfg,
    )
model.freeze()


'''