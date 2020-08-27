provider "aws" {
  region = "eu-west-1"
}

resource "random_string" "redshift_password" {
  length = 16
}

module "redshift" {
  source              = "../"
  name                = "example-1"
  cidr_blocks         = ["0.0.0.0/0"]
  database            = "example_db"
  password            = random_string.redshift_password.result
  publicly_accessible = local.publicly_accessible
  logging_bucket      = "example-redshift-logging-bucket"
  subnet_ids          = module.vpc.redshift_subnets_ids
  username            = "root"
  vpc_id              = module.vpc.id
  tags                = { Environment = "test", Stack = "Example" }
}
