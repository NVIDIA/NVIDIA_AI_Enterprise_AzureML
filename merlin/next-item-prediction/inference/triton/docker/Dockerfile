FROM nvcr.io/nvidia/merlin/merlin-pytorch:22.12
EXPOSE 8000 8001 8002
# filepath is to where the models are mounted in the container 
CMD tritonserver --model-store=/models/ensemble/ensemble

