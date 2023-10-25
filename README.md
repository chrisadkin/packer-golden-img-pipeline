# Overview

This repo illustrates how to create a golden image pipeline using Packer and Terraform, specifically, how to build an virtual machine image using Packer, store the metadata for it in a HCP Packer registry and then finally
create a virtual machine using an image referenced from the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/golden_image_workflow.png?raw=true">

The Packer element of the workflow largely mirrors the contents of [this HashiCorp tutorial](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-image-metadata)

The pipeline comprises of the following stages:

1. Create Packer HCL files for your golden images, these are essentially text files which specify how to create images in Packer's dialect of HashiCorp Configuration Language (HCL)

2. Log into HashiCorp Cloud Platform and create a Packer registry, note that this stores metadata associated with Packer built images and not the actual images themselves https://www.hashicorp.com/cloud

2. Build the image:
   - You will need to specify environment variables for the whatever cloud provide the HCL file uses, for AWS for example you would specific:

     export AWS_ACCESS_KEY_ID="<anaccesskey>"
     export AWS_SECRET_ACCESS_KEY="<asecretkey>"

 
