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
