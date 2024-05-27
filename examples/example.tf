provider "aws" {
  region = "eu-west-1"
}

resource "random_string" "redshift_password" {
  length = 16
}

module "redshift" {
  source              = "../"
  name                = "example-1"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  database            = "example_db"
  password            = random_string.redshift_password.result
  publicly_accessible = true
  username            = "root"
  tags                = { Environment = "test", Stack = "Example" }

  logging = {
    bucket_name          = "example-redshift-logging-bucket"
    log_destination_type = "s3"
  }
}
