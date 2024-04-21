# Crypto Bot Infrastructure
This repository contains the infrastructure for the Crypto Bot project. The infrastructure is built using Terraform and is hosted on AWS.

## Prerequisites
- Terraform
- AWS CLI
- AWS Account

## Setup
1. Clone the repository
2. Create a `.env` file in the root directory of the repository and add the following environment variables:
    ```
    TF_VAR_aws_access_key=your_aws_access_key
    TF_VAR_aws_secret_key=your_aws_secret_key
    TF_VAR_aws_region=your_aws_region
    TF_VAR_instance_type=your_instance_type
    TF_VAR_ami=your_ami
    ```
3. Run `make init` to initialize the Terraform configuration
4. Run `make plan` to see the changes that will be applied
5. Run `make apply` to apply the changes

## Destroy
To destroy the infrastructure, run `make destroy`.

## Connect to the EC2 instance
To connect to the EC2 instance, run `make connect`. It will SSH into the instance using the key pair created on `make apply`.

## Makefile
The Makefile contains the following commands:
- `load_env`: Loads the environment variables from the `.env` file
- `init`: Initializes the Terraform configuration and loads the environment variables using `load_env`
- `plan`: Shows the changes that will be applied
- `apply`: Applies the changes to the infrastructure and creates the key pair on `~/.ssh/` directory
- `destroy`: Destroys the infrastructure
- `connect`: Connects to the EC2 instance by retrieving the public dns and using the key pair created on `~/.ssh/` directory

