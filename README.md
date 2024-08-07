# Automated Azure VM Deployment with ARM Template and GitHub Actions

## Overview

This project automates the deployment of an Azure Virtual Machine (VM) using an Azure Resource Manager (ARM) template and a PowerShell script. The PowerShell script, which runs as an extension on the initial VM, creates five additional VMs. We can manually upload the ARM template into our Azure account and run the powershell script within `AzureCloudShell`.

We can also automate the whole deployment process using through `GitHub Actions`, ensuring `continuous integration and deployment(CI/CD)`.

## Repository Structure

Azure_ARM_VM
├── .github
│ └── workflows
│ └── deploy-vm.yaml
├── createVms.ps1
└── deploy-vm-with-script.json
└── README.md

- **.github/workflows/deploy-vm.yaml**: GitHub Actions workflow file to automate the deployment process.
- **createVms.ps1**: PowerShell script to create additional VMs.
- **deploy-vm-with-script.json**: ARM template to deploy the initial VM and attach the PowerShell script.
- **README**: Project documentation markdown.

## Prerequisites

1. **Azure Subscription**: Ensure you have an active Azure subscription.
2. **Service Principal**: Create a service principal with the necessary permissions to deploy resources.
3. **GitHub Repository**: Set up a GitHub repository for your project.
4. **Azure CLI**: Installed locally for testing purposes.

## Setup and Deployment

### Clone the GitHub Repository

    ```bash
    git clone https://github.com/ntanwir10/Azure_ARM_VM.git
    cd my-repo

### In order to complete your ARM template, create a `blob storage` within `storage accounts` with `public access` and upload the shell script. You can do this either from Azure UI or using `Azure CLI` by using the following step -

#### 1. Create a Storage Account

`az storage account create --name mystorageaccount --resource-group myResourceGroup --location eastus --sku Standard_LRS`

#### 2. Create a container within the storage account with public access

`az storage container create --account-name mystorageaccount --name mycontainer --public-access blob`

#### 3. Upload your PowerShell script to the container

`az storage blob upload --account-name mystorageaccount --container-name mycontainer --name createVms.ps1 --file createVms.ps1`

#### 4. Fetch the URL of the uploaded script

`az storage blob url --account-name mystorageaccount --container-name mycontainer --name createVms.ps1`
This command will output the URL of the PowerShell script, something like `https://mystorageaccount.blob.core.windows.net/mycontainer/createVms.ps1`

### Create a Service Principal needed for github actions

Create a Service Principal with Contributor role, which has the permissions to create and manage resources in your Azure subscription. Run the following command:

`az ad sp create-for-rbac --name "myServicePrincipal" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID`
Replace `YOUR_SUBSCRIPTION_ID` with your actual Azure subscription ID. This command will return a JSON object with your Service Principal credentials:

    {
    "appId": "YOUR_CLIENT_ID",
    "displayName": "myServicePrincipal",
    "name": "http://myServicePrincipal",
    "password": "YOUR_CLIENT_SECRET",
    "tenant": "YOUR_TENANT_ID"
    }
`Note down the appId, password, and tenant values, as you will need them for configuring GitHub secrets.`

### Set Up GitHub Secrets

Go to your GitHub repository and Click on Settings > Secrets > New repository secret.
Add the following secrets:

    AZURE_SUBSCRIPTION_ID: Your Azure subscription ID.
    AZURE_CLIENT_ID: Your Azure service principal client ID.
    AZURE_CLIENT_SECRET: Your Azure service principal client secret.
    AZURE_TENANT_ID: Your Azure tenant ID.
    ADMIN_USERNAME: Your VM admin username.
    ADMIN_PASSWORD: Your VM admin password.
