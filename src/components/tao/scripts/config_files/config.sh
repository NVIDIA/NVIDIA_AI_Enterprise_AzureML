#!/bin/bash

# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

subscription_id="ab221ca4-f098-422d-ab2f-5073b3851e68"
resource_group="NVIDIA_COMPONENTS_AND_PIPELINES"
registry_name="Registry_Test3"
#registry_name="NVIDIA-NGC-Test"
workspace="NVIDIA_COMPONENTS_TEST7"
vmsize="standard-nc6s-v3"
nvidia_product="tao"
container="tfv3.22.05-tf1.15.4"
compute_name="gpu-cluster-${vmsize}"
product_subfolder="object_detection/detectnet_v2"
#product_subfolder="object_detection/facenet"
pipeline_path=pipelines/${nvidia_product}/${container}/${product_subfolder}
num_epochs="4"
