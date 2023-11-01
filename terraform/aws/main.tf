resource "aws_vpc" "ubuntu-focal" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "ubuntu-focal-hardened"
  }
}

resource "aws_subnet" "ubuntu-focal" {
  vpc_id            = aws_vpc.ubuntu-focal.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "ubuntu-focal-hardened"
  }
}

data "hcp_packer_image" "learn-packer-ubuntu" {
  bucket_name     = "learn-packer-ubuntu"
  channel         = "latest"
  cloud_provider  = "aws"
  region          = "us-east-2"
}

resource "aws_instance" "ubuntu-focal" {
  ami           = data.hcp_packer_image.learn-packer-ubuntu.cloud_image_id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ubuntu-focal.id

  tags = {
    Name = "ubuntu-focal-hardened"
  }
}
