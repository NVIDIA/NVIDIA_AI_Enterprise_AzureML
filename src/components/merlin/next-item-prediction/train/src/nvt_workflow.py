# Copyright (c) 2023, NVIDIA CORPORATION, All rights reserved.

import cudf
import numpy as np
import nvtabular as nvt
from merlin.core.dispatch import encode_list_column, flatten_list_column_values
from merlin.schema import Tags

from defaults import categorize_start_index, max_sequence_length


def define_nvt_workflow() -> nvt.Workflow:
    """
    This defines the NVT workflow that will be used to transform data for training AND serving.
    """
    weekday_sin = ["timestamp"] >> nvt.ops.LambdaOp(
        lambda col: encode_list_column(
            col,
            get_cycled_feature_value_sin(
                cudf.to_datetime(flatten_list_column_values(col), unit="s").dt.weekday
                + 1,
                7,
            ),
        )
    )

    truncated_cat = (
        ["category"]
        >> nvt.ops.Categorify(start_index=categorize_start_index)
        >> nvt.ops.ListSlice(-max_sequence_length, pad=True)
        >> nvt.ops.ValueCount()
        >> nvt.ops.Rename(name="category-list")
    )
    truncated_item_id = (
        ["item_id"]
        >> nvt.ops.Categorify(start_index=categorize_start_index)
        >> nvt.ops.ListSlice(-max_sequence_length, pad=True)
        >> nvt.ops.AddMetadata(tags=[Tags.ITEM, Tags.ID, Tags.ITEM_ID])
        >> nvt.ops.ValueCount()
        >> nvt.ops.Rename(name="item_id-list")
    )
    truncated_dayofweek_sin = (
        weekday_sin
        >> nvt.ops.ListSlice(-max_sequence_length, pad=True)
        >> nvt.ops.AddMetadata(tags=[Tags.CONTINUOUS])
        >> nvt.ops.ValueCount()
        >> nvt.ops.Rename(name="et_dayofweek_sin-list")
    )

    selected_features = truncated_cat + truncated_dayofweek_sin + truncated_item_id
    workflow = nvt.Workflow(selected_features)
    return workflow


# Derive cyclical features: Defines a custom lambda function
def get_cycled_feature_value_sin(col, max_value):
    value_scaled = (col + 0.000001) / max_value
    value_sin = np.sin(2 * np.pi * value_scaled)
    return value_sin
