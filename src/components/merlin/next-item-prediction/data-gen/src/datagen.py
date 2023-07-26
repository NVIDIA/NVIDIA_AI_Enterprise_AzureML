#!/usr/bin/env python
import calendar
import datetime

import click
import numpy as np
import pandas as pd

from pathlib import Path
import os

def generate_synthetic_data(
    start_date: datetime.date, end_date: datetime.date, rows_per_day: int = 100_000
) -> pd.DataFrame:

    number_of_days = (end_date - start_date).days
    total_number_of_rows = number_of_days * rows_per_day

    # Generate a long-tail distribution of item interactions. This simulates that some items are
    # more popular than others.
    long_tailed_item_distribution = np.clip(
        np.random.lognormal(3.0, 1.0, total_number_of_rows).astype(np.int64), 1, 50000
    )

    # generate random item interaction features
    df = pd.DataFrame(
        {
            "session_id": np.random.randint(70000, 80000, total_number_of_rows),
            "item_id": long_tailed_item_distribution,
        },
    )

    # generate category mapping for each item-id
    df["category"] = pd.cut(df["item_id"], bins=334, labels=np.arange(1, 335)).astype(
        np.int64
    )

    max_session_length = 60 * 60  # 1 hour

    def add_timestamp_to_session(session: pd.DataFrame):
        random_start_date_and_time = calendar.timegm(
            (
                start_date
                + datetime.timedelta(days=np.random.randint(0, number_of_days))
                # Add time offset within the day
                + datetime.timedelta(seconds=np.random.randint(0, 86_400))
            ).timetuple()
        )
        session["timestamp"] = random_start_date_and_time + np.clip(
            np.random.lognormal(3.0, 1.0, len(session)).astype(np.int64),
            0,
            max_session_length,
        )
        return session

    df = df.groupby("session_id").apply(add_timestamp_to_session).reset_index()

    return df

@click.command()
@click.option("--output-location", help="Output folder location")
@click.option("--start-date", help="Execution date in YYYY-MM-DD format.")
@click.option("--end-date", help="Execution date in YYYY-MM-DD format.")
def main(output_location, start_date, end_date): 
    df = generate_synthetic_data(datetime.datetime.strptime(start_date, "%Y-%m-%d"), datetime.datetime.strptime(end_date, "%Y-%m-%d"))
    output_folder = Path(output_location) 
    output_file_name = "raw-data.parquet"
    out_path = os.path.join(output_folder, output_file_name)
    df.to_parquet(out_path)

if __name__ == "__main__":
    main()
