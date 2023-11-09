import os
import re
from functools import partial
from operator import is_not
from typing import List
import re
import gevent.ssl

import numpy as np
import tritonclient.http as httpclient
from tritonclient.utils import np_to_triton_dtype

STOP_WORDS = [""]
BAD_WORDS = [""]
RANDOM_SEED = 0

'''

GPT_PROMPT_TEMPLATE = ( 
    "<extra_id_0>System\n"
    "A chat between a curious user and an artificial intelligence assistant." 
    "The assistant gives helpful, detailed, and polite answers to the user's questions.\n"
    "<extra_id_1>User\n"
    "{prompt}\n"
    "<extra_id_1>Assistant\n"
)
'''
GPT_PROMPT_TEMPLATE = """System: This is a chat between a user and an artificial intelligence assistant. The assistant gives helpful, detailed, and polite answers to the user's questions based on the context. The assistant should also indicate when the answer cannot be found in the context.
 
{context_1}
 
User: Please give a full and complete answer for the question. {question_1}
 
Assistant:"""
 
context_1 = "Climate change refers to long-term shifts in temperatures and weather patterns. Such shifts can be natural, due to changes in the sun’s activity or large volcanic eruptions. But since the 1800s, human activities have been the main driver of climate change, primarily due to the burning of fossil fuels like coal, oil and gas."
question_1 = "What happened in the 1800s?"

'''
GPT_PROMPT_TEMPLATE = (
    "<extra_id_0>System\n"
    "You are a helpful and resourceful assistant."
    "<extra_id_1>User\n"
    "What is the fastest water animal?\n"
    "<extra_id_1>Assistant\n"
)
'''

def prepare_tensor(name, input):
    t = httpclient.InferInput(
        name, input.shape, np_to_triton_dtype(input.dtype))
    t.set_data_from_numpy(input)
    return t


def generate_inputs(  
	prompt: str,
	tokens: int = 300,
	temperature: float = 1.0,
	top_k: float = 1,
	top_p: float = 0,
	beam_width: int = 1,
	repetition_penalty: float = 1,
	length_penalty: float = 1.0,
	stream: bool = False,
) -> httpclient.InferInput:
	"""Create the input for the triton inference server."""
	query = np.array(prompt).astype(object)
	request_output_len = np.array([tokens]).astype(np.uint32).reshape((1, -1))
	runtime_top_k = np.array([top_k]).astype(np.uint32).reshape((1, -1))
	runtime_top_p = np.array([top_p]).astype(np.float32).reshape((1, -1))
	temperature_array = np.array([temperature]).astype(np.float32).reshape((1, -1))
	len_penalty = np.array([length_penalty]).astype(np.float32).reshape((1, -1))
	repetition_penalty_array = (
		np.array([repetition_penalty]).astype(np.float32).reshape((1, -1))
	)
	random_seed = np.array([RANDOM_SEED]).astype(np.uint64).reshape((1, -1))
	beam_width_array = np.array([beam_width]).astype(np.uint32).reshape((1, -1))
	streaming_data = np.array([[stream]], dtype=bool)

	inputs = [
		prepare_tensor("text_input", query),
		prepare_tensor("max_tokens", request_output_len),
		prepare_tensor("top_k", runtime_top_k),
		prepare_tensor("top_p", runtime_top_p),
		prepare_tensor("temperature", temperature_array),
		prepare_tensor("length_penalty", len_penalty),
		prepare_tensor("repetition_penalty", repetition_penalty_array),
		prepare_tensor("random_seed", random_seed),
		prepare_tensor("beam_width", beam_width_array),
		prepare_tensor("stream", streaming_data),
	]
	return inputs
	


def main():
	question='Who is the fastest water animal?'
	api_key=""
    system_prompt = "You are a helpful, respectful and honest assistant. Always answer as helpfully as possible, while being safe. Please ensure that your responses are positive in nature."
	prompt = GPT_PROMPT_TEMPLATE.format(context_1=context_1, question_1=question_1)
	#prompt = GPT_PROMPT_TEMPLATE.format(prompt=question)
	inputs = generate_inputs([[prompt]], 
						  tokens=100,
						  temperature=1.0,
						  top_k=1,
						  top_p=0,
						  beam_width=1,
						  repetition_penalty=1.0,
						  length_penalty=1.0)
	
	client = httpclient.InferenceServerClient(url="nemo-gpt8b-endpoint-1.westeurope.inference.ml.azure.com/",ssl=True, ssl_context_factory=gevent.ssl._create_default_https_context)
	
	headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ api_key), 'azureml-model-deployment': 'nemo-gpt8b-deployment-1'}
	
	# Check status of triton server
	health_ctx = client.is_server_ready(headers=headers)
	print("Is server ready - {}".format(health_ctx))

    # Check status of model
	model_name = "ensemble"
	status_ctx = client.is_model_ready(model_name, "1", headers)
	print("Is model ready - {}".format(status_ctx))
	
	result = client.infer("ensemble", inputs=inputs, headers=headers)
	result_str = "".join(
		[val.decode("utf-8") for val in result.as_numpy("text_output").tolist()]
	)
	print(result_str)
	
if __name__ == "__main__":
    main()
