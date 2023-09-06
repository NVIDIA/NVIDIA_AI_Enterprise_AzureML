import os
import subprocess
squad_dir =r"/home/mohit/nemo_azureML/data/SQuAD"

# Extract subset of lines from squad_train.jsonl
train_input_file = f"{squad_dir}/squad_train.jsonl"
train_output_file = f"{squad_dir}/squad_short_train.jsonl"
train_command = f"head -2000 {train_input_file} > {train_output_file}"
subprocess.run(train_command, shell=True)

# Extract subset of lines from squad_val.jsonl
val_input_file = f"{squad_dir}/squad_val.jsonl"
val_output_file = f"{squad_dir}/squad_short_val.jsonl"
val_command = f"head -200 {val_input_file} > {val_output_file}"
subprocess.run(val_command, shell=True)
