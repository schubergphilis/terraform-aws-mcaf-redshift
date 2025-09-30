provider "aws" {
  region = "eu-west-1"
}

resource "random_string" "redshift_password" {
  length = 16
}

module "redshift" {
  source              = "../.."
  name                = "example-1"
  database            = "example_db"
  password            = random_string.redshift_password.result
  publicly_accessible = true
  subnet_ids          = module.vpc.public_subnet_ids
  username            = "root"
  tags                = { Environment = "test", Stack = "Example" }

  logging = {
    bucket_name          = "example-redshift-logging-bucket"
    log_destination_type = "s3"
  }

  security_group_egress_rules = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "All outbound traffic"
      ip_protocol = "-1"
    }
  ]

  security_group_ingress_rules = [
    {
      cidr_ipv4   = module.vpc.cidr_block
      description = "Allow inbound traffic from the VPC itself"
      from_port   = 5439
      to_port     = 5439
      ip_protocol = "tcp"
    },
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "All inbound traffic"
      ip_protocol = "-1"
    }
  ]
}

module "vpc" {
  source  = "schubergphilis/mcaf-vpc/aws"
  version = "~> 3.0.0"

  name                = "redshift-vpc"
  availability_zones  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr_block          = "10.10.0.0/16"
  private_subnet_bits = 24
  public_subnet_bits  = 24
  tags                = { Environment = "test", Stack = "Example" }
}
