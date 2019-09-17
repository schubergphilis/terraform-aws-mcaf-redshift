locals {
  bucket     = "${var.stack}-redshift"
  elastic_ip = var.publicly_accessible ? aws_eip.default[0].public_ip : null
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : aws_subnet.public[*].id
  vpc_id     = data.aws_subnet.selected.vpc_id
}

data "aws_subnet" "selected" {
  id = local.subnet_ids[0]
}

resource "aws_eip" "default" {
  count = var.publicly_accessible ? 1 : 0
  vpc   = true
  tags  = merge(var.tags, map("Name", "${var.stack}-redshift"))
}

resource "aws_security_group" "default" {
  name        = "${var.stack}-redshift"
  description = "Access to Redshift"
  vpc_id      = local.vpc_id
  tags        = var.tags

  ingress {
    description = "All inbound traffic"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
    self        = true
  }

  ingress {
    description = "All inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_redshift_subnet_group" "default" {
  name       = var.stack
  subnet_ids = local.subnet_ids
  tags       = var.tags
}

resource "aws_redshift_parameter_group" "default" {
  name        = var.stack
  description = "Hardened security for Redshift Clusters"
  family      = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = true
  }

  parameter {
    name  = "require_ssl"
    value = true
  }
}

resource "aws_s3_bucket" "logging" {
  count         = var.logging ? 1 : 0
  bucket        = local.bucket
  force_destroy = var.force_destroy
  policy        = data.aws_iam_policy_document.logging.json
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  count                   = var.logging ? 1 : 0
  bucket                  = aws_s3_bucket.logging[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_redshift_service_account" "main" {}

data "aws_iam_policy_document" "logging" {
  statement {
    sid = "Put bucket policy needed for Redshift audit logging"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.main.arn]
    }
  }

  statement {
    sid = "Get ACL bucket policy needed for Redshift audit logging"
    actions = [
      "s3:GetBucketAcl"
    ]
    resources = [
      "arn:aws:s3:::${local.bucket}"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.main.arn]
    }
  }
}

resource "aws_redshift_cluster" "default" {
  cluster_identifier                  = var.stack
  database_name                       = var.database
  master_username                     = var.username
  master_password                     = var.password
  allow_version_upgrade               = true
  automated_snapshot_retention_period = 1
  cluster_parameter_group_name        = aws_redshift_parameter_group.default.name
  cluster_subnet_group_name           = aws_redshift_subnet_group.default.name
  cluster_type                        = var.cluster_type
  elastic_ip                          = local.elastic_ip
  encrypted                           = true
  final_snapshot_identifier           = var.final_snapshot_identifier
  iam_roles                           = var.iam_roles
  node_type                           = var.node_type
  number_of_nodes                     = var.number_of_nodes
  publicly_accessible                 = var.publicly_accessible
  skip_final_snapshot                 = var.skip_final_snapshot
  vpc_security_group_ids              = [aws_security_group.default.id]
  tags                                = var.tags

  logging {
    enable        = var.logging
    bucket_name   = aws_s3_bucket.logging[0].id
    s3_key_prefix = "redshift-audit-logs/"
  }
}
