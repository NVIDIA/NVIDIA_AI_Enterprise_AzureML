# Copyright (c) 2023, NVIDIA CORPORATION, All rights reserved.

import os

import pandas as pd
import torch
from torch import nn


class TopkT4RecModel(nn.Module):
    """
    This is a simple pytorch layer with a forward step only, which will take the predictions from
    the t4rec model and keep only the top K results based on their scores.

    Parameters

    t4rec_model: Your trained Transformers4Rec model
    top_k: the number of items to return. Default is -1, which will return all items.
    """

    def __init__(self, t4rec_model, top_k=-1):
        super(TopkT4RecModel, self).__init__()
        self.t4rec_model = t4rec_model
        self.top_k = top_k

    def forward(self, x, **kwargs):
        all_preds = self.t4rec_model(x, **kwargs)
        if self.top_k == -1:
            return all_preds
        _, preds_sorted_item_ids = torch.topk(all_preds, k=self.top_k, dim=-1)
        return preds_sorted_item_ids


class InverseIDLookupModel(nn.Module):
    """
    This is another forward-stpe layer that will take the IDs returned from the topk layer and
    convert them to actual item_ids.
    """

    def __init__(
        self, t4rec_topk_model, id_mapping: torch.tensor, start_index: int = 0
    ):
        """
        Parameters:

        t4rec_topk_model: A Transformers4Rec model that has already been wrapped with the TopkT4RecModel
                     layer. It is expected that this model returns the categorified "Merlin ID" of
                     the top K recommended items.
        id_mapping: The unique mapping of item_id's to Merlin IDs produced by NVTabular. This is
                    stored in the `unique.item_id.parquet` file. See [reverse_id_mapping] for
                    how best to load this file.
        start_index: The value of `start_index` used with the NVTabular workflow. This is critial
                     to provide to ensure that the right item_ids are returned.
        """
        super(InverseIDLookupModel, self).__init__()
        self.t4rec_model = t4rec_topk_model
        self._mapping = id_mapping
        self._start_index = start_index

    def forward(self, x, **kwargs):
        """
        Example of how the forward pass works:

        The `self._mapping` tensor is an _ordered_ list of the actual item_id's. The order is
        very specific and was produced by NVTabular in the file `unique.item_id.parquet`. That
        parquet file has two columns that look like this:

                  item_id  item_id_size
        0           <oov>             0
        1       214829878         56236
        2       214829880         26788
        ...

        The first row where all unknown or "out of vocabulary" item_ids will be mapped. The second
        is the most popular item, third is the second most popular, and so on.

        We read just the `item_id` column and store it as `self._mapping`. So for a training set
        with N items, the length will be `N + 1` to include the <oov> spot.

        [<oov>, most_popular_item, next_most_popular, ...]

        In this AI Workflow, we add padding to the input lists using `nvt.ops.ListSlice`. This pads
        the list of items in the session with the value `0`. So that <padding> and <oov> are not
        both mapped to the index `0`, we set start_index=1, so all <oov> items get mapped to 1 instead
        of 0.

        The Transformers4Rec is aware of this, but the NVTabular mapping is not! Transformers4Rec
        returns a score for all N items plus the <oov> index plus the <padding> index. So a response
        from the model will have N + 2 floats:

        Model returns: [<score for padding field>, <score for oov field>, <score for most popular item>, ...]

        NVT Mapping:   [<oov>, most_popular_item, next_most_popular, ...]

        What is returned from the TopkT4RecModel layer is a list of indices for the recommended
        items. The index it would return for <most popular item> in this situation is `2`, but in
        `self._mapping` it is actually at index `1`.

        Because of all of this, we must offset the values returned from TopkT4RecModel by
        `start_index` positions. In our example, that offset is 1 position.
        """
        all_preds = self.t4rec_model(x, **kwargs) - self._start_index
        all_preds[all_preds < 0] = 0
        return self._mapping[all_preds]


def reverse_id_mapping(categories_dir: str, col_name: str = "item_id") -> torch.tensor:
    """
    Loads the categories file and gets the mapping from the index value to the Item ID.

    By convention, the "merlin IDs" are the row number for each item_id in this DataFrame.
    """
    filename = os.path.join(categories_dir, f"unique.{col_name}.parquet")
    df = pd.read_parquet(filename)
    values = df[col_name].fillna(-1).values
    return torch.tensor(values).cuda()
