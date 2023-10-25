# Overview

This repo illustrates how to create a golden image pipeline using Packer and Terraform, specifically, how to build an virtual machine image using Packer, store the metadata for it in a HCP Packer registry and then finally
create a virtual machine using an image referenced from the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/golden_image_workflow.png?raw=true">

The Packer element of the workflow largely mirrors the contents of [this HashiCorp tutorial](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-image-metadata), the rest of the repo provides additional context and links the Packer element to Terraform.

The pipeline comprises of the following stages:

1. Packer HCL file creation for golden images, these are essentially text files which specify how to create images in Packer's dialect of HashiCorp Configuration Language (HCL).

2. Building an image via Packer and pushing its metadata to HCP Packer - what is essentially an image registry.

3. Virtual machine creation via Terraform using image details obtained from HCP Packer.

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
