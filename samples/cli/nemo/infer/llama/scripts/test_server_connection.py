import urllib.request
import json
import os
import ssl
import argparse
import gevent.ssl
import tritonclient.http as tritonhttpclient


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--base_url", type=str, default="https://triton-ft-endpt1.eastus.inference.ml.azure.com")
    parser.add_argument("--token", type=str, default="oNfpQnyznkkKpG8cWBXN2SF6iPTD4dUa")
    args = parser.parse_args()

    scoring_uri = args.base_url[8:]
    api_key = args.token
    print(api_key)
    print(scoring_uri)
    triton_client = tritonhttpclient.InferenceServerClient(
        url=scoring_uri,
        ssl=True,
        ssl_context_factory=gevent.ssl._create_default_https_context,
    )
 
    headers = {'Content-Type':'application/json', 'Authorization':('Bearer '+ api_key), 'azureml-model-deployment': 'triton-ft-deployment-1' }


    # Check status of triton server
    health_ctx = triton_client.is_server_ready(headers=headers)
    print("Is server ready - {}".format(health_ctx))

    # Check status of model
    model_name = "fastertransformer"
    status_ctx = triton_client.is_model_ready(model_name, "1", headers)
    print("Is model ready - {}".format(status_ctx))
