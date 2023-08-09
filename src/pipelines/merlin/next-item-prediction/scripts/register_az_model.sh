#!/bin/bash

az ml model create --type triton_model --name next-item --version 1 --path <job_output>/mymodel/ensemble/

#replace <job_output> w/ output of pipeline job 
