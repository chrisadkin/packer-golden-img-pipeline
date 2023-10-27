# Terraform Virtual Machine Deployment Instructions

Irrespective of where a virtual machine is created, the key component in a Terraform configuration that enables this is the ```hcp_packer_image``` datasource, this 
acts as the link between an image in the HCP Packer regsitry and the resource in the Terraform configuration used for creating the actual virtual machine.  

The code for the ```hcp_packer_image``` datasource block can be obtained via the HCP console.

For Azure, click on the image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_datasource.png?raw=true">

The same thing can be done for AWS images, click on the image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_datasource.png?raw=true">
