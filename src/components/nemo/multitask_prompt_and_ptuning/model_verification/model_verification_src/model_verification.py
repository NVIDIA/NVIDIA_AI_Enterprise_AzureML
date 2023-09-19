import argparse

from nemo.collections.nlp.models.language_modeling.megatron_gpt_model import MegatronGPTModel


parser = argparse.ArgumentParser()

parser.add_argument("--model",type=str, help= "Path to the model")
args = parser.parse_args()

print(MegatronGPTModel.list_available_models())

print(args.model)
