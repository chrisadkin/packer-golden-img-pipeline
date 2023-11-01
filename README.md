# Overview

This repo illustrates how to create a golden image pipeline using Packer and Terraform, specifically, how to build an virtual machine image using Packer, store the metadata for it in a HCP Packer registry and then finally
create a virtual machine using an image referenced from the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/golden_image_workflow.png?raw=true">

The Packer element of the workflow largely mirrors the contents of [this HashiCorp tutorial](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-image-metadata), the rest of the repo provides additional context and links the Packer element to Terraform.

The pipeline comprises of the following stages:

1. Packer HCL file creation for golden images, these are essentially text files which specify how to create images in Packer's dialect of HashiCorp Configuration Language (HCL).

2. Building an image via Packer and pushing its metadata to HCP Packer.

3. As part of the ```packer build``` process, the image metadata is pushed to a HCP Packer registry.

4. Create a Terraform configuration that references the image in the HCP Packer registry via the [hcp-packer-terraform data source](https://developer.hashicorp.com/packer/docs/datasources/hcp/hcp-packer-image).

# Prerequisites
## Generic Prerequisites

- [Packer 1.7.10](https://developer.hashicorp.com/packer/downloads) installed locally
- [Terraform 1.6.2](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed locally
- A [HashiCorp Cloud Platform](https://www.hashicorp.com/cloud) account

## AWS Prerequisites
- An AWS account with credentials set as local environment variables. These credentials must have permissions to create, modify, and delete EC2 instances. Refer to the documentation to find the full list IAM permissions required to run the amazon-ebs builder.

## Azure Prerequisites
- An Azure account
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli#install) installed locally

# Instructions

1. Build and push images to a HCP Packer registry by following the instructions [here](https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/PACKER.md)

2. Once an image has been successfully pushed up to the HCP Packer registry, virtual machines can be created using these images per these instructions.

- [Create an Azure virtual machine using a HCP Packer image](https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/TERRAFORM_AZURE.md)

- [Create an AWS EC2 instance using a HCP Packer image](https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/TERRAFORM_AWS.md)

# Terraform Cloud / Enterprise HCP Packer Run Task Integration

Terraform Cloud and Terraform Enterprise add further value to this solution via run task integration, which validates that the machine images in your Terraform configuration are not revoked for being insecure or outdated, as
covered by [this](https://developer.hashicorp.com/packer/tutorials/hcp/setup-tfc-run-task) tutorial.
