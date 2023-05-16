# Copyright (c) 2017-2020, NVIDIA CORPORATION.  All rights reserved.
import argparse
import os
from PIL import Image
import mlflow

def parse_args(args=None):
    """parse the arguments."""
    parser = argparse.ArgumentParser(description='Tool to upload images to be previewed on AzureML')

    parser.add_argument(
        "--image_dir",
        type=str,
        required=True,
        help="Directory to find images to upload."
    )

    parser.add_argument(
        "--num_images",
        type=int,
        required=True,
        help="Number of images to upload."
    )

    return parser.parse_args(args)


def getImagesFilenames(dirName,numFiles):
    listOfFile = os.listdir(dirName)
    allFiles = list()
    # Iterate over all the entries until enough have been captured
    sofar=0
    for entry in listOfFile:
        prefix = entry.split(".")[1]
        # Create full path
        if prefix=='png':
            if sofar<numFiles:
                # Create full path
                fullPath = os.path.join(dirName, entry)
                print(fullPath)
                allFiles.append(fullPath)
                sofar = sofar+1
            else:
                return allFiles
    return allFiles

def uploadImages(imagesToUpload):
    for image in imagesToUpload:
        img = Image.open(image)
        filename= image.split("/")[-1]
        mlflow.log_image(img, filename)

def main(args=None):
    args = parse_args(args)
    image_dir = args.image_dir
    num_images = args.num_images

    if not os.path.exists(image_dir):
        print("This provided image directory does not exist.")
        return

    imagesToUpload = getImagesFilenames(image_dir,num_images)
    uploadImages(imagesToUpload)

if __name__ == "__main__":
    main()
