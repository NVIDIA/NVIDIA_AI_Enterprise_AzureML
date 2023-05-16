import argparse
import os
import time

parser = argparse.ArgumentParser()
parser.add_argument("--input_data", type=str)
parser.add_argument("--conn_str", type=str)
parser.add_argument("--container_name", type=str)
parser.add_argument("--model", type=str)
parser.add_argument("--output_data", type=str)

args = parser.parse_args()

print("sample_input_data path: %s" % args.input_data)
print("sample_conn_str path: %s" % args.conn_str)
print("sample_container_name path: %s" % args.container_name)
print("sample_model path: %s" % args.model)
print("sample_output_data path: %s" % args.output_data)

os.chdir(args.input_data)
os.system('cp -r * /tmp')
os.chdir('/tmp')

from azure.storage.blob import BlobClient


#
#  Copy Model from Data Asset
#
os.chdir(args.model)
os.system('cp -r * /tmp/models')
os.chdir('/tmp')

from azure.storage.blob import BlobServiceClient
blob_service_client = BlobServiceClient.from_connection_string(args.conn_str)
container_client = blob_service_client.get_container_client(args.container_name)
while(True):
    b = 0
    for file in container_client.walk_blobs('inputs/', delimiter='/'):
        filename = os.path.basename(file.name)
        filename_no_ext = os.path.splitext(filename)[0]
        ext = os.path.splitext(filename)[1].lower()
        if ext == '.end':
            b = 1
        if ext == '.mp4' or ext == '.mov':
            # Read input file
            try:
                blob = BlobClient.from_connection_string(conn_str=args.conn_str,container_name=args.container_name, blob_name=file.name)
                with open('/tmp/'+ filename, "wb") as f:
                    f.write(blob.download_blob().readall())
            except Exception as e:
                print(e)

            # Run Deepstream
            filename_no_ext = filename_no_ext + '_' + time.strftime("%Y%m%d-%H%M%S")
            os.chdir('/tmp/deepstream-lpr-app')
            os.system('./deepstream-lpr-app 1 1 0 infer /tmp/' + filename + ' /tmp/'+ filename_no_ext)

            # Copy output to storage blob
            blob = BlobClient.from_connection_string(conn_str=args.conn_str,container_name=args.container_name, blob_name= 'outputs/'+ filename_no_ext + '.264')
            try:
                with open('/tmp/' + filename_no_ext + '.264',"rb") as f:
                    blob.upload_blob(f)
                    print('lprout.264 uploaded to container: ' + args.container_name + ' successfully')
            except Exception as e:
                print(e)

            blob_client = blob_service_client.get_blob_client(container=args.container_name, blob=file.name)
            blob_client.delete_blob()
        time.sleep(1)
    if b == 1:
        break
    
    time.sleep(10)

