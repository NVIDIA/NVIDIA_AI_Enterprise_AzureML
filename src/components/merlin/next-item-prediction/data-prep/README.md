# Next Item Prediction - Data Prep Component
## Data Preprocessing Overview: 
In data preprocessing, we will split the entire synthetic data set into daily partitions, with one folder per day in YYYY-MM-DD format. This is necessary for our simulated dataset, but in reality it is assumed that new interaction data will be collected and made available in some sort of Data Lake each day.

Because a single session can cross the date boundary, we want to make sure that each full session ends up in the same date partition. To do this, we group the data by session_id and find the earliest timestamp for the session, and put all associated rows into the date partition of the earliest interaction. For example, all three of the events in the following table would be put in the 2014-05-08 directory. 

[image of sample events](events-sample.png)

## Pre-grouping by session_id
 Before we start to use this data to train models, we will pre-group by session_id, so that all of the interactions in a given session are contained in one row. The data stored in each of the date-partitioned parquet files looks like this:
```
timestamp                                item_id       category
[1396444666, 1396445162, 1396445412]      [214716935, 214774687, 214832672]      [0, 0, 0]
            [1396420745, 1396420733]                 [214826715, 214826835]         [0, 0]
            [1396460527, 1396460844]                 [214532036, 214700432]         [0, 0]
[1396451237, 1396451257, 1396451287]      [214712235, 214581489, 214602605]      [0, 0, 0]
```
If you would like to learn more, please refer to the follow tech brief sections: [Feature Engineering w/ NVTabular](https://docs.nvidia.com/ai-enterprise/workflows-recommender-systems-ai/0.1.0/combined-development.html#feature-engineering-with-nvtabular) and [Understanding Schemas](https://docs.nvidia.com/ai-enterprise/workflows-recommender-systems-ai/0.1.0/combined-development.html#understanding-schemas)

## Component inputs & outputs: 
- inputs: 
    - data_prep_input: directory synthetically generated raw data 
- outputs: 
    - data_prep_output: directory with preprocessed data, ready for training 