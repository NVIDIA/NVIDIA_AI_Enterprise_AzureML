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

#pipeline_conn_str="DefaultEndpointsProtocol=https;AccountName=josephwstorageaccount;AccountKey=uy0fYfjWfLFkH/TCtVB71DMYtpDvfq/5J+0zqLXFIK+kBgVoUCR/C+LiqBY6n0cdfkaeaGrIbchEkMl97Hxc8w==;EndpointSuffix=core.windows.net"
pipeline_conn_str="DefaultEndpointsProtocol=https;AccountName=josephwstorageaccount;AccountKey=uy0fYfjWfLFkH\/TCtVB71DMYtpDvfq\/5J+0zqLXFIK+kBgVoUCR\/C+LiqBY6n0cdfkaeaGrIbchEkMl97Hxc8w==;EndpointSuffix=core.windows.net"
pipeline_container_name="azureml"
subscription="NV-WWFO"
registry_name="NVIDIARegistryTest1"
compute_name="gpu-Standard-NC16as-T4-v3"
resource_group="jwu-ml"
workspace="main"

