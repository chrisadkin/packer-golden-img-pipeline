# Terraform Virtual Machine Deployment Instructions

The key component in a Terraform configuration that enables this is the ```hcp_packer_image``` datasource, this acts as the link between an image in the HCP Packer registry and the resource in the Terraform configuration used for creating the actual virtual machine.  

The code for the ```hcp_packer_image``` datasource block can be obtained via the HCP console.

For Azure, click on the image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_datasource.png?raw=true">

The same thing can be done for AWS images, click on the image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_datasource.png?raw=true">

# Azure

This section assumes that an Azure image has already been created per [these instructions]()

1. Clone this repo unless this has already been done:
```
$ git clone https://github.com/chrisadkin/packer-golden-img-pipeline
```

2. Change directory to packer-golden-img-pipeline/terraform/azure:
```
$ cd packer-golden-img-pipeline/terraform/azure
```

3. Log into Azure:
```
$ az login
```
   
   
