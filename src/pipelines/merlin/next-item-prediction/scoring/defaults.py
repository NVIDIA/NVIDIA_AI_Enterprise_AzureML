# Copyright (c) 2023, NVIDIA CORPORATION, All rights reserved.

# The max sequence length for each session. All user sessions will
# be clipped/padded to be this length.
max_sequence_length = 20

# Number of results to return.
top_k_results = 20
categorize_start_index = 1

d_model = 320

_T4R_MODEL_NAME = "mymodel"
T4R_MODEL_NAME_WORKFLOW = f"{_T4R_MODEL_NAME}_workflow"
T4R_MODEL_NAME_MODEL_NOTRACE = f"{_T4R_MODEL_NAME}_model_notrace"
T4R_MODEL_NAME_ENSEMBLE = f"{_T4R_MODEL_NAME}_ensemble"

# Defines the maximum length of sparse columns.
SPARSE_MAX = {
    "et_dayofweek_sin-list": max_sequence_length,
    "item_id-list": max_sequence_length,
    "category-list": max_sequence_length,
}

# Hyperparameters for TabularSequenceFeatures.from_schema
tabular_sequence_features = {
    "d_output": d_model,
    "continuous_projection": 64,
    "aggregation": "concat",
    "masking": "mlm",
}

# Hyperparameters for tr.trainer.T4RecTrainingArguments
t4rec_training_arguments = dict(
    max_sequence_length=max_sequence_length,
    data_loader_engine="nvtabular",
    num_train_epochs=1,
    dataloader_drop_last=False,
    per_device_train_batch_size=384,
    per_device_eval_batch_size=512,
    learning_rate=0.0005,
    fp16=True,
    report_to=[],
    logging_steps=200,
)
