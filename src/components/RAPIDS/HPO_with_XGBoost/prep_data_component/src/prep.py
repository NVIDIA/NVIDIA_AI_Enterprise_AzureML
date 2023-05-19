import argparse
import os
from pathlib import Path
import cudf
import matplotlib.pylab as plt
import pandas as pd
import numpy as np
import json

parser = argparse.ArgumentParser("prep")
parser.add_argument("--raw_data", type=str, help="Path/URL to the Parquet file")
parser.add_argument("--prep_data",type=str, help="Path to the cleaned and filtered data")

args = parser.parse_args()
columns_to_read = ['passenger_count', 'trip_distance','RatecodeID','PULocationID','DOLocationID','payment_type','fare_amount','extra','mta_tax','tip_amount','tolls_amount','improvement_surcharge','congestion_surcharge']

# Read the Parquet files into the CuDF dataframe
cudf_dataframe = cudf.read_parquet(args.raw_data,columns=columns_to_read)
print(cudf_dataframe.dtypes)


#Remove rows with any missing values
#cudf_dataframe_no_total = cudf_dataframe.drop(['tpep_pickup_datetime', 'tpep_dropoff_datetime', 'store_and_fwd_flag', 'total_amount'], axis=1)
cudf_dataframe_no_total_no_missing_values = cudf_dataframe.dropna()
print(cudf_dataframe_no_total_no_missing_values.shape)
print("Dataframe columns")
print(cudf_dataframe.columns)
print(cudf_dataframe_no_total_no_missing_values)
# Save the data
clean_data = cudf_dataframe_no_total_no_missing_values.to_csv(Path(args.prep_data))
