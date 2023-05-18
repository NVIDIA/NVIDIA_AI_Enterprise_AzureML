# NVIDIA AI Enterprise AzureML Registry (Private Preview)
[test]
The Registry contains AzureML Resources that would enable Azure Machine Learning Users to set up end-to-end MLOPs workflows using NVIDIA AI Enterprise Software.

## NVIDIA AI Enterprise

NVIDIA AI Enterprise is an end-to-end platform for building accelerated production AI.

it includes a library of full-stack software including NVIDIA AI Workflows, frameworks, pretrained models and infrastructure optimization which streamline the development and deployment of production-ready applications for generative AI, speech AI, vision AI, cybersecurity, and more.

## AzureML Resources

### AzureML Environments

Contains the libraries that a given piece of code needs to run inside AzureML

### AzureML Command Components

Modular reusable pieces of code, with parameterized inputs and outputs

### AzureML Pipeline Components

They define entire workflows, by interconnecting the inputs and outputs of several command components

## Supported NVIDIA AI Enterprise Software

This private preview includes software from the following NVIDIA AI Enterprise SDKs

### TAO Toolkit

NVIDIA TAO Toolkit is low-code, AI model development toolkit that simplifies and accelerates the creation of custom production-ready models to power vision AI applications. The TAO Toolkit lets you use the power of transfer learning to fine-tune NVIDIA pretrained models with your own data and optimize for inference—without needing AI expertise. Developers can train and fine-tune State-of-the-art Vision Transformers (ViT) with TAO for object detection, image classification, segmentation, and other CV tasks. Now developers can easily train, deploy, and manage AI models at scale using NVIDIA TAO Toolkit with Azure ML. 

### RAPIDS

The NVIDIA RAPIDS™ suite of software libraries, gives you the freedom to execute end-to-end data science and analytics pipelines entirely on GPUs. It relies on NVIDIA® CUDA® primitives for low-level compute optimization but exposes that GPU parallelism and high-bandwidth memory speed through user-friendly Python interfaces.

### MONAI

MONAI is the domain-specific, open-source Medical AI framework that drives research breakthroughs and accelerates AI into clinical impact. MONAI unites doctors with data scientists to unlock the power of medical data to build deep learning models and deployable applications for medical AI workflows. MONAI provides the essential domain specific tools for data labeling, model training, and application deployment. With MONAI, it is easy to develop, reproduce and standardize on medical AI lifecycles.

### Triton

NVIDIA Triton™, an open-source inference serving software, standardizes AI model deployment and execution and delivers fast and scalable AI in production.

### DeepStream

DeepStream SDK is a complete streaming analytics toolkit based on GStreamer for AI-based multi-sensor processing, video, audio, and image understanding. It’s ideal for vision AI developers, software partners, startups, and OEMs building IVA apps and services. Developers can now create stream processing pipelines that incorporate neural networks and other complex processing tasks such as tracking, video encoding/decoding, and video rendering. DeepStream pipelines enable real-time analytics on video, image, and sensor data.

## NVIDIA AI Enterprise AzureML GitHub Repo
The [NVIDIA AI Enterprise AzureML GitHub Repo](https://github.com/NVIDIA/NVIDIA_AI_Enterprise_AzureML/tree/main) has two types of documents contained into two main folders: src and samples


### src folder
Has the AzureML CLI 2.0 files use to publish the AzureML Resources into the NVIDIA AI Enterprise AzureML Registry

It is first indexed by AzureML Resource Type and then by NVIDIA AI Enterprise SDK


### samples folder

It contains examples of how to use the AzureML Resources contained in the NVIDIA AI Enterprise AzureML Registry to implement end-to-end MLOPs workflows, from data acquisition to model endpoint deployment



