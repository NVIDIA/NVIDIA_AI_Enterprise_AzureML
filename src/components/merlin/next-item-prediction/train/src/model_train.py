# Copyright (c) 2023, NVIDIA CORPORATION, All rights reserved.

import gc

import torch
from merlin.io.dataset import Dataset
from merlin.schema.io.tensorflow_metadata import TensorflowMetadata
from merlin_standard_lib import Schema as T4RSchema
from nvtabular.workflow import Workflow
from transformers4rec import torch as tr
from transformers4rec.torch.ranking_metric import NDCGAt, RecallAt

import mlflow
from defaults import (
    d_model,
    max_sequence_length,
    t4rec_training_arguments,
    tabular_sequence_features,
)


def train_t4r_model(
    workflow: Workflow,
    eval_dataset: Dataset,
    train_dataset: Dataset,
    output_dir: str,
):
    # The very first thing we'll do is fit the workflow to the training dataset. We do this first
    # because the workflow.output_schema is used to define the T4R model's input schema.
    workflow.fit(train_dataset)
    print("------------Workflow input schema------------")
    print(workflow.input_schema)
    print("------------Workflow output schema------------")
    print(workflow.output_schema)

    # In order to load the schema into the right format for Transformers4Rec, we unfortunately have
    # to serialize/deserialize it. Work to integrate these two different schemas is underway.
    tf_schema = TensorflowMetadata.from_merlin_schema(workflow.output_schema)
    t4r_schema = T4RSchema().from_proto_text(tf_schema.to_proto_text())

    # Define input module to process tabular input-features and to prepare masked inputs.
    input_module = tr.TabularSequenceFeatures.from_schema(
        t4r_schema, max_sequence_length=max_sequence_length, **tabular_sequence_features
    )

    # Define the evaluation top-N metrics and the cut-offs
    metrics = [
        NDCGAt(top_ks=[20, 40], labels_onehot=True),
        RecallAt(top_ks=[20, 40], labels_onehot=True),
    ]

    # Define Next item prediction-task
    prediction_task = tr.NextItemPredictionTask(weight_tying=True, metrics=metrics)

    # Define the config of the XLNet Transformer architecture
    transformer_config = tr.XLNetConfig.build(
        d_model=d_model, n_head=8, n_layer=2, total_seq_length=max_sequence_length
    )

    # Get the end-to-end model
    model = transformer_config.to_torch_model(input_module, prediction_task)

    training_args = tr.trainer.T4RecTrainingArguments(
        output_dir=output_dir, **t4rec_training_arguments
    )

    recsys_trainer = tr.Trainer(
        model=model, args=training_args, schema=t4r_schema, compute_metrics=True
    )

    fit_and_evaluate(
        workflow,
        recsys_trainer,
        eval_dataset,
        train_dataset,
    )

    model = model.cuda()

    # set hf_format property to ensure model outputs tensor of predictions and not the dict
    # expected by hugging face
    model.hf_format = False

    return model


def fit_and_evaluate( 
    workflow: Workflow,
    trainer,
    eval_dataset,
    train_dataset,
):
    """
    Util function for time-window based fine-tuning using the T4rec Trainer class.
    Iteratively train using data of a given index and evaluate on the validation data
    of the following index.

    Parameters
    ----------
    workflow: nvt.Workflow
        The NVTabular workflow that we will fit to the training data and use to transform both
        the training and validation data.
    trainer:
        The trainer.
    start_time_index: int
        The start index for training, it should match the partitions of the data directory
    end_time_index: int
        The end index for training, it should match the partitions of the  data directory
    input_dir: str
        The input directory where the parquet files were saved based on partition column

    Returns
    -------
    indexed_by_time_metrics: dict
        The dictionary of ranking metrics: each item is the list of scores over time indices.
    """
    indexed_by_time_metrics = {}

    # 1. Define the training and evaluation Datasets
    print("PRE-TRANSFORM EVAL DATA")
    print(eval_dataset.to_ddf().compute())

    train_data = workflow.transform(train_dataset)
    eval_data = workflow.transform(eval_dataset)

    print("POST-TRANSFORM EVAL DATA")
    print(eval_data.to_ddf().compute())

    # 2. Train the model
    trainer.train_dataset_or_path = train_data
    trainer.reset_lr_scheduler()
    trainer.train()

    # 3. Evaluate on valid data
    trainer.eval_dataset_or_path = eval_data
    eval_metrics = trainer.evaluate(metric_key_prefix="eval")
    print("\n***** Evaluation results *****\n")
    for key in sorted(eval_metrics.keys()):
        if "at_" in key:
            print(" %s = %s" % (key.replace("_at_", "@"), str(eval_metrics[key])))
            mlflow.log_metric(key, eval_metrics[key])
            if "indexed_by_time_" + key.replace("_at_", "@") in indexed_by_time_metrics:
                indexed_by_time_metrics[
                    "indexed_by_time_" + key.replace("_at_", "@")
                ] += [eval_metrics[key]]
            else:
                indexed_by_time_metrics[
                    "indexed_by_time_" + key.replace("_at_", "@")
                ] = [eval_metrics[key]]

    # free GPU for next day training
    wipe_memory()

    return indexed_by_time_metrics


def wipe_memory():
    gc.collect()
    torch.cuda.empty_cache()
