# Obtain The Terraform HCP Packer Datasource

The key component in a Terraform configuration that enables this is the ```hcp_packer_image``` datasource, this acts as the link between an image in the HCP Packer registry and the resource in the Terraform configuration used for creating the actual virtual machine.  

The code for the ```hcp_packer_image``` datasource block can be obtained via the HCP console.

Click on the AMI image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_aws_datasource.png?raw=true">

# Apply The Terraform Config

This section assumes that an Azure image has already been created per [these instructions]()

1. Clone this repo unless this has already been done:
```
$ git clone https://github.com/chrisadkin/packer-golden-img-pipeline
```

2. Change directory to packer-golden-img-pipeline/terraform/azure:
```
$ cd packer-golden-img-pipeline/terraform/aws
```

3. Set the environment variables required by the AWS provider in the config, substituting the placeholders below with you own values:
```
$ export AWS_ACCESS_KEY_ID     = "<Your AWS access key Id goes here>"
$ export AWS_SECRET_ACCESS_KEY = "<Your AWS access key secret goes here>"
```

4. Open the ```main.tf``` file and note:

- the hcp_packer_image datasource at the top of the file
```
data "hcp_packer_image" "learn-packer-ubuntu" {
  bucket_name     = "learn-packer-ubuntu"
  channel         = "latest"
  cloud_provider  = "aws"
  region          = "us-east-2"
}
```
- the ```aws_instance``` resource in which the image id is referred to:
```
resource "aws_instance" "ubuntu-focal" {
  ami           = data.hcp_packer_image.learn-packer-ubuntu.cloud_image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ubuntu-focal.id

  tags = {
    Name = "ubuntu-focal-hardened"
  }
}
```

5. Install the terraform providers required by the congiguration:
```
$ terraform init
```   

6. Check the resources that the configuration will create:
```
$ terraform plan
```
   the tail of the output this rsults in should state the following:
```
   Plan: 3 to add, 0 to change, 0 to destroy.
```

7. Apply the configuration:
```
$ terraform apply -auto-approve
```
   the tail of the output from this should look like:
```
aws_vpc.ubuntu-focal: Creating...
aws_vpc.ubuntu-focal: Creation complete after 3s [id=vpc-0a01bf311f0f1dba8]
aws_subnet.ubuntu-focal: Creating...
aws_subnet.ubuntu-focal: Creation complete after 1s [id=subnet-081fa8bc9b72fbd91]
aws_instance.ubuntu-focal: Creating...
aws_instance.ubuntu-focal: Still creating... [10s elapsed]
aws_instance.ubuntu-focal: Still creating... [20s elapsed]
aws_instance.ubuntu-focal: Still creating... [30s elapsed]
aws_instance.ubuntu-focal: Creation complete after 33s [id=i-0e22f7081a6bb1b59]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
```

8. Log into the AWS console and check what EC2 instances are present:
   
<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/aws_console_ec2.png?raw=true">
