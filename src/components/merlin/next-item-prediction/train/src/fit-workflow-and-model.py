#!/usr/bin/env python
import click
import datetime
import os
import tempfile
from pathlib import Path
from shutil import copyfile
from typing import Tuple

import cloudpickle
import mlflow.pytorch
from merlin.io.dataset import Dataset
from merlin_standard_lib import Schema
from numba import config

import layers
import mlflow
from layers import InverseIDLookupModel, TopkT4RecModel, reverse_id_mapping
from model_train import train_t4r_model
from nvt_workflow import define_nvt_workflow

config.CUDA_LOW_OCCUPANCY_WARNINGS = 0  # type:ignore

# needed for ensemble service
from nvtabular.inference.triton.ensemble import export_pytorch_ensemble
from nvtabular.workflow import Workflow

import defaults
import nvt_workflow
from defaults import (
    _T4R_MODEL_NAME,
    SPARSE_MAX,
    T4R_MODEL_NAME_ENSEMBLE,
    T4R_MODEL_NAME_MODEL_NOTRACE,
    T4R_MODEL_NAME_WORKFLOW,
    categorize_start_index,
    top_k_results,
)


def generate_dataloader(schema, dataset, sparse_max, batch_size=128, seq_length=20):
    from transformers4rec.torch.utils.data_utils import MerlinDataLoader

    loader = MerlinDataLoader.from_schema(
        schema,
        dataset,
        batch_size=batch_size,
        max_sequence_length=seq_length,
        shuffle=False,
        sparse_as_dense=True,
        sparse_max=sparse_max,
    )
    return loader


def training_datasets(
    data_dir: str, current_date: datetime.date, num_eval_days: int, num_train_days: int
) -> Tuple[Dataset, Dataset]:
    """
    Figures out which date paths to use for training and evaluation.

    The most recent `num_eval_days` are used for evaluation, and the `num_train_days` before that are
    used for training.
    """
    if num_eval_days == 0 or num_train_days == 0:
        raise ValueError("Must have at least 1 training date and 1 evaluation date")

    eval_days = [
        os.path.join(
            data_dir,
            (current_date - datetime.timedelta(days=i)).strftime("%Y-%m-%d"),
            "*.parquet",
        )
        for i in range(num_eval_days)
    ]
    train_days = [
        os.path.join(
            data_dir,
            (
                current_date
                - datetime.timedelta(days=num_eval_days)
                - datetime.timedelta(days=i)
            ).strftime("%Y-%m-%d"),
            "*.parquet",
        )
        for i in range(num_train_days)
    ]
    return (Dataset(eval_days), Dataset(train_days))

def update_nvt_model(
    model_name: str, ensemble_output_path: str, triton_model_version: int = 1
):
    preprocessing_path = os.path.join(ensemble_output_path, model_name + "_nvt")
    copyfile(
        os.path.join(os.path.dirname(__file__), "triton", "workflow_model.py"),
        os.path.join(preprocessing_path, str(triton_model_version), "model.py"),
    )


@click.command()
@click.option("--input-location", help="Input folder location")
@click.option("--output-location", help="Output folder location")
@click.option("--date", help="Execution date in YYYY-MM-DD format.")
def main(input_location: str, output_location: str, date: str): 
    BASE_OUTPUT_DIR = output_location
    WORKFLOW_OUTPUT = "nvt_workflow"
    MODEL_OUTPUT_DIR = "model" 
    MODEL_OUTPUT_DIR_NOTRACE = "model_notrace"
    PREPROC_FOLDER = input_location 

    # Definitions of the training/eval dates
    CURRENT_DATE = date
    NUM_EVAL_DAYS = 2
    NUM_TRAIN_DAYS = 3

    workflow = define_nvt_workflow()

    # Train the model. 
    eval_dataset, train_dataset = training_datasets(
        PREPROC_FOLDER,
        datetime.datetime.strptime(CURRENT_DATE, "%Y-%m-%d"),
        NUM_EVAL_DAYS,
        NUM_TRAIN_DAYS,
    )

    MODEL_OUTPUT_DIR = os.path.join(
        BASE_OUTPUT_DIR, _T4R_MODEL_NAME, MODEL_OUTPUT_DIR
    )
    MODEL_OUTPUT_DIR_NOTRACE = os.path.join(
        BASE_OUTPUT_DIR, _T4R_MODEL_NAME, MODEL_OUTPUT_DIR_NOTRACE
    )
    WORKFLOW_OUTPUT = os.path.join(
        BASE_OUTPUT_DIR, _T4R_MODEL_NAME, WORKFLOW_OUTPUT
    )

    for output_dir in [MODEL_OUTPUT_DIR, MODEL_OUTPUT_DIR_NOTRACE, WORKFLOW_OUTPUT]:
        Path(output_dir).mkdir(parents=True, exist_ok=True)
        
    model = train_t4r_model(workflow, eval_dataset, train_dataset, MODEL_OUTPUT_DIR)

    # This is required to properly serialize the get_cycled_feature_value_sin function that is used
    # inside the NVT workflow.
    cloudpickle.register_pickle_by_value(defaults)
    cloudpickle.register_pickle_by_value(nvt_workflow)

    workflow.save(WORKFLOW_OUTPUT)
    print(f">>> WORKFLOW SAVED TO {WORKFLOW_OUTPUT}")

    id_mapping = reverse_id_mapping(os.path.join(WORKFLOW_OUTPUT, "categories"))
    topk_model = TopkT4RecModel(model, top_k_results)
    model = InverseIDLookupModel(topk_model, id_mapping, categorize_start_index)

    # Saves the non-jit-traced version of the model to be used for serving with
    # the legacy nvtabular.inference.triton.ensemble.export_pytorch_ensemble function
    # model.save(MODEL_OUTPUT_DIR_NOTRACE)  # type:ignore
    with open(
        os.path.join(MODEL_OUTPUT_DIR_NOTRACE, "t4rec_model_class.pkl"), "wb"
    ) as out:
        cloudpickle.register_pickle_by_value(layers)
        cloudpickle.dump(model, out)
    
    ENSEMBLE_OUTPUT_FOLDER = "ensemble" 

    ENSEMBLE_OUTPUT_FOLDER = os.path.join(
        BASE_OUTPUT_DIR, _T4R_MODEL_NAME, ENSEMBLE_OUTPUT_FOLDER
    )
    export_pytorch_ensemble(
        model,
        workflow,
        SPARSE_MAX,
        _T4R_MODEL_NAME,
        ENSEMBLE_OUTPUT_FOLDER,
    )

    # There's an issue with the model.py file that was just exported for doing the NVTabular
    # workflow transformation. This repo contains a modified version that will work with
    # ragged-list inputs. We need to copy it there.
    # Later versions of Merlin should have this fixed

    update_nvt_model(_T4R_MODEL_NAME, ENSEMBLE_OUTPUT_FOLDER)

    # Azure Storage deletes 0 byte items/ directories. To prevent part of the ensemble from being deleted, we add in an anchor file   
    mymodel = "mymodel"
    missing_dir = os.path.join(ENSEMBLE_OUTPUT_FOLDER, mymodel, str(1))
    Path(missing_dir).mkdir(parents = True, exist_ok = True)
    file_path = os.path.join(missing_dir, 'anchor.txt')
    with open(file_path, 'w') as file: 
        file.write("anchor file")

    print("Finished training")


if __name__ == "__main__": #files need to be passed from azure's storage locations. 
    main()