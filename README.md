# Zero Trust Network Setup with Twingate and Terraform

This guide will help you set up a Zero Trust Network using Twingate and Terraform. Follow the steps below to get started.

## Prerequisites

Ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Twingate Account](https://www.twingate.com/) with API token

## Setup Instructions

### 1. Set the Twingate API Token

You need to set your Twingate API token as an environment variable. Replace `<YOUR_TOKEN>` with your actual Twingate API token.

```sh
export TWINGATE_API_TOKEN="<YOUR_TOKEN>"
```

2. Initialize Terraform
Before you can apply the Terraform scripts, you need to initialize the working directory that contains your Terraform configuration files.

```sh
terraform init
```

3. Apply the Terraform Configuration
Apply the Terraform scripts to set up the infrastructure.

```sh
terraform apply
```
You will be prompted to confirm the application of the changes. Type yes and press Enter.

Directory Structure
```css
Copier le code
.
└── terraform
    ├── main.tf
    ├── twingate.tf
    └── variables.tf
```
main.tf: The main Terraform configuration file.
variables.tf: Contains variable definitions.
outputs.tf: Defines the outputs of the Terraform execution.