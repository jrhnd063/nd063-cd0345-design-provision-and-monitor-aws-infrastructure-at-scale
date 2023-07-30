# Designate a cloud provider, region, and credentials
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

# Specify ID of existing VPC.
data "aws_vpc" "existing" {
  id = "vpc-07c47405aa4cf9443"
}

# Specify ID of existing public subnet.
data "aws_subnet" "existing" {
  id = "subnet-044cc0983c972c22e"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "udacity_t2" {
  count         = 4
  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing.id

  tags = {
    Name = "Udacity T2"
  }
}

# Provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "udacity_m4" {
  count         = 2
  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "m4.large"
  subnet_id     = data.aws_subnet.existing.id

  tags = {
    Name = "Udacity M4"
  }
}