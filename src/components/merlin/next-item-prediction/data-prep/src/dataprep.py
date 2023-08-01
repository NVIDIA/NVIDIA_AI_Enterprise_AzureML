#!/usr/bin/env python
import calendar
import datetime

import click
import cudf
import numpy as np
import pandas as pd

from pathlib import Path
import os

@click.command()
@click.option("--input-location", help="Input folder location")
@click.option("--output-location", help="Output folder location")
@click.option("--start-date", help="Execution date in YYYY-MM-DD format.")
@click.option("--end-date", help="Execution date in YYYY-MM-DD format.")
def preprocess_data(input_location: str, output_location: str, start_date: str, end_date: str):
    output_folder = Path(output_location) 
    output_folder.mkdir(parents = True, exist_ok=True)
    output_file_name = "preprocessed.parquet"

    data = Path(input_location)
    data = os.path.join(data, "raw-data.parquet")
    interactions_df = cudf.read_parquet(data)

    # Sorts the dataframe by session and timestamp, to remove consecutive repetitions
    interactions_df = interactions_df.sort_values(["session_id", "timestamp"])
    past_ids = interactions_df["item_id"].shift(1).fillna()
    session_past_ids = interactions_df["session_id"].shift(1).fillna()

    # Keeping only no consecutive repeated in session interactions
    interactions_df = interactions_df[
        ~(
            (interactions_df["session_id"] == session_past_ids)
            & (interactions_df["item_id"] == past_ids)
        )
    ]

    print(f"Table of interactions has {len(interactions_df):,} rows")
    print(interactions_df.head())
    
    first_date_per_session = (
        interactions_df.groupby("session_id").agg({"timestamp": "min"}).reset_index()
    )

    interactions_df = interactions_df.merge(
        first_date_per_session, on="session_id", suffixes=("", "_min")
    )

    interactions_df["day"] = cudf.to_datetime(
        interactions_df.timestamp_min, unit="s"
    ).dt.strftime("%Y-%m-%d")

    unique_days = interactions_df.day.unique().values_host


    for day in unique_days: 
        day_df = interactions_df[interactions_df.day == day]
        out_dir = os.path.join(output_folder, day)
        out_path = os.path.join(out_dir, output_file_name)
        del day_df["day"]
        del day_df["timestamp_min"]
        # del day_df["index"]
        day_df = day_df.groupby("session_id").agg("collect").reset_index(drop=True)
        if not os.path.exists(out_dir):        
            os.mkdir(out_dir)
        # print(day_df)
        day_df.to_parquet(out_path)

if __name__ == "__main__":
    preprocess_data()
