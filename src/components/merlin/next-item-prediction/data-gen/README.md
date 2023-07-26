# Next Item Prediction - Data Gen Component
## Component overview: 
This workflow uses a dataset with similar characteristics to the yoochoose dataset from the 2015 Recsys Challenge. More information is available about the dataset on Kaggle [here](https://www.kaggle.com/datasets/chadgostopp/recsys-challenge-2015).

We use a script to generate 1,000,000 user/item interactions per day for an 85 day period. The columns in the generated data set are:
- Session ID - the id of the session. In one session there are one or many buying events. Could be represented as an integer number.
- Timestamp - the time when the buy occurred. Format of YYYY-MM-DDThh:mm:ss.SSSZ
- Item ID - the unique identifier of item that has been bought.
- Category - the context of the click. This could be an item category i.e. sport.

Both this and the data-prep components of this workflow can be swapped out for your own data. There are many tools people use to prepare this data, from Spark jobs to SQL in data warehouses. In order to have a drop-in replacement for our training data, you must produce parquet files with the following fields and types:
[image of parquet fields + types](parquet-sample.png)

## Component inputs & outputs: 
- inputs: N/A
- outputs: 
    - data_gen_output: synthetically generated raw data, to be used to run the workflow. passed to next component for data prep
