import argparse
import numpy as np
import os
from PIL import Image

import gevent.ssl
import tritonclient.http as tritonhttpclient


def preprocess(img_content):
    """Pre-process an image to meet the size, type and format
    requirements specified by the parameters.
    """
    c = 3
    h = 224
    w = 224

    img = Image.open(img_content)

    sample_img = img.convert("RGB")

    resized_img = sample_img.resize((w, h), Image.BILINEAR)
    resized = np.array(resized_img)
    if resized.ndim == 2:
        resized = resized[:, :, np.newaxis]

    typed = resized.astype(np.float32)

    # scale for INCEPTION
    scaled = (typed / 128) - 1

    # Swap to CHW
    ordered = np.transpose(scaled, (2, 0, 1))

    # Channels are in RGB order. Currently model configuration data
    # doesn't provide any information as to other channel orderings
    # (like BGR) so we just assume RGB.
    img_array = np.array(ordered, dtype=np.float32)[None, ...]
  
#    return ordered
    return img_array


def postprocess(max_label):
    """Post-process results to show the predicted label."""

    absolute_path = os.path.abspath(__file__)
    folder_path = os.path.dirname(absolute_path)
    label_path = os.path.join(folder_path, "recognitionv2_name_list.txt")
    print(label_path)

    label_file = open(label_path, "r")
    labels = label_file.read().split("\n")
    label_dict = dict(enumerate(labels))
    final_label = label_dict[max_label]

    return final_label


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--base_url")
    parser.add_argument("--token")
    parser.add_argument("--image_path", type=str, default="https://aka.ms/peacock-pic")
    args = parser.parse_args()

    scoring_uri = args.base_url[8:]
    triton_client = tritonhttpclient.InferenceServerClient(
        url=scoring_uri,
        ssl=True,
        ssl_context_factory=gevent.ssl._create_default_https_context,
    )

    headers = {}
    headers["Authorization"] = f"Bearer {args.token}"

    # Check status of triton server
    health_ctx = triton_client.is_server_ready(headers=headers)
    print("Is server ready - {}".format(health_ctx))

    # Check status of model
    model_name = "nvidia-tao-dinov2-retail-object-recognition"
    status_ctx = triton_client.is_model_ready(model_name, "1", headers)
    print("Is model ready - {}".format(status_ctx))

    img_data = preprocess(args.image_path)
    
    # Populate inputs and outputs
    input = tritonhttpclient.InferInput("input", img_data.shape, "FP32")
    input.set_data_from_numpy(img_data)
    inputs = [input]
    output = tritonhttpclient.InferRequestedOutput("probs")
    outputs = [output]

    result = triton_client.infer(model_name, inputs, outputs=outputs, headers=headers)
#    probs = result.as_numpy("probs")
    max_label = np.argmax(result.as_numpy("probs"))
    label_name = postprocess(max_label)
    print(label_name)
