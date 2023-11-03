# $\textcolor{green}{\textsf{MONAI 3D Segmentation sample}}$

In this tutorial, you will:

* Provision a fully functional environment in your own Azure subscription
* Run a sample of MONAI machine learning pipeline in Azure ML

it is based on the following MONAI tutorial: https://github.com/Project-MONAI/tutorials/blob/main/3d_segmentation/brats_segmentation_3d.ipynb

## Prerequisites


To enjoy this quick deployment, you will need to:

* have an active [Azure subscription](https://azure.microsoft.com) that you can use for development purposes,
* have permissions to create resources, set permissions, and create identities in this subscription (or at least in one resource group),
  * Note that to set permissions, you typically need _Owner_ role in the subscription or resource group - _Contributor_ role is not enough. This is key for being able to _secure_ the setup.
* [install the Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).

## Deploy to Azure

1. Click on the button below. It will open in Azure Portal a page to deploy the resources in your subscription.

| Button | Description |
| :-- | :-- |
| [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNVIDIA%2NVIDIA_AI_Enterprise_AzureML%2Fmain%2samples%2Fpython%2F3D-image-segmentation%2monai%2Fdeployment%2Farm%2Fmonai-setup.json) | This setup is intended only for demo purposes. The data is still accessible by the users of your subscription when opening the storage accounts, and data exfiltration is possible. |

> Notes:
>
> * If someone already provisioned a demo with the same name in your subscription, change **Demo Base Name** parameter to a unique value.
> * For provisioning GPU or CPU, you need just use a GPU/CPU SKU value for the "Compute SKU" parameter, `Standard_NC96ads_A100` for instance. An overview of the GPU SKU's available in Azure can be found [here](https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-gpu). Beware though, SKU availability may vary depending on the region you choose, so you may have to use different Azure regions instead of the default ones.

2.  Once the automatic deployment is finished you can open new workspace
    and after that related Machine Learning Studio

3.  Next you need to create a compute instance to do development work in  Machine Learning Studio. Click Compute icon in the vertical menu on the left. Next
    select Compute instances and [create
    one](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-create-manage-compute-instance?view=azureml-api-2&tabs=azure-studio).    
    
3.  Once you have dev compute instance running you need to open Notebooks File Explorer with your notebooks to run. In the beginning it will be empty

5.  Click on Open terminal button and open SSH client to your Compute Instance. In this session clone NVIDIA/NVIDIA_AI_Enterprise_AzureML repository (or just what you will use)

6. Refresh Notebook File Explorer to see that you have samples and src under your name in Notebook File exploreer

7. Open MONAI sample notebooks and run them

> **NOTES:**
>
> The current sampleas are tested using
> Standard_NC96ads_A100, but you could use smaller Azure sizes or clusters too.
>
> The sample is using [Kaggle](https://www.kaggle.com/datasets/dschettler8845/brats-2021-task1).
> BraTS2021_Training_Data.tar.

## Running sample notebooks 

The sample has 3 notebooks:

 - [Loading Data and Training the Model](./notebooks/load_and_train.ipynb)
 - [Deploy trained Model](./notebooks/deploy_model.ipynb)
 - [Test the model using End Point](./notebooks/test_model.ipynb)

> **NOTES:**
>
> If you are more familiar with cli based approach then use related MONAI samplea
