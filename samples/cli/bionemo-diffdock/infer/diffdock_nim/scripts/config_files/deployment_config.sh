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
resource_group="NVIDIA_COMPONENTS_AND_PIPELINES_WEST3"
workspace="NVIDIA_COMPONENTS_WEST3"
location="westus3"

ngc_key="azdwMG00YXNicWVzcnFrN3ZqMnFtcTAyb2U6MWMwZjg4NWYtOWFhZC00YjBmLWFmNDQtNmJjNmRkOGIxZTI3"
email_address="mreyesgomez@nvidia.com"

acr_registry_name="nvidiacomponentswest3registry"

registry_name="NVIDIA-AI-Enterprise-Preview"
keyvault_name="NGC-Credentials"
image_name=diffdock-nim_ncd
ngc_container="nvcr.io/nim/nvidia/bionemo-diffdock:1.2.0"
endpoint_name="diffdock-nim-endpoint-aml-1"
endpoint_id="6cf0fc3a-9ee8-42a8-bfd1-2aee8b218bd3"
deployment_name="diffdock-nim-deployment-aml-1"
model_name="vista3d"
model_version="1"
instance_type="Standard_NC48ads_A100_v4"
environment_version="1"
