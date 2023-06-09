#!/bin/bash

source scripts/config_files/config.sh

az ml compute create -f compute_clusters/${vmsize}/create-cluster.yml