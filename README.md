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
<!-- 2. **Service Principal**: Create a service principal with the necessary permissions to deploy resources. -->
3. **GitHub Repository**: Set up a GitHub repository for your project.
4. **Azure CLI**: Installed locally for testing purposes.

## Setup and Deployment

### Step 1: Create and Clone the GitHub Repository

1. Create a new repository on GitHub.
2. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/your-username/my-repo.git
    cd my-repo
