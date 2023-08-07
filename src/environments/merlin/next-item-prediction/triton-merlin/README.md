## Merlin container 
Merlin container w/ right ports forwarded for Triton deployment. Based on [version 22.12 of Merlin](nvcr.io/nvidia/merlin/merlin-pytorch:22.12)

To properly push this image to ACR, run the ```push_triton_to_acr.sh``` script. To get the container registry associated with your workspace, run the ```az ml workspace show``` and refer to ```container_registry```. 