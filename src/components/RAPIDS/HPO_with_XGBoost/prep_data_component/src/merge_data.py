import os
import pandas as pd
import cudf



parquet_files = ['yellow_tripdata_2023-01.parquet',
                 'yellow_tripdata_2023-02.parquet',
                 ]
dfs = [cudf.read_parquet(file) for file in parquet_files]
dfs = cudf.concat(dfs)
dfs.to_parquet('merged_data.parquet')