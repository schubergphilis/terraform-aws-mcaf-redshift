locals {
  elastic_ip        = var.publicly_accessible ? aws_eip.default[0].public_ip : null
  subnet_group_name = var.subnet_ids == null ? "default" : (var.redshift_subnet_group != null ? var.redshift_subnet_group : var.name)
}

resource "aws_eip" "default" {
  count = var.publicly_accessible ? 1 : 0
  vpc   = true
  tags  = merge(var.tags, { "Name" = "redshift-${var.name}" })
}

resource "aws_security_group" "default" {
  name        = "redshift-${var.name}"
  description = "Access to Redshift"
  vpc_id      = var.vpc_id
  tags        = var.tags

  ingress {
    description = "All inbound traffic"
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks
  }

  ingress {
    description = "All inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  dynamic "ingress" {
    for_each = var.additional_ingress_rules

    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_group_ids
    }
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_blocks
  }

  dynamic "egress" {
    for_each = var.additional_egress_rules

    content {
      description     = egress.value.description
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      security_groups = egress.value.security_group_ids
      prefix_list_ids = egress.value.prefix_list_ids
    }
  }
}

resource "aws_redshift_subnet_group" "default" {
  count      = var.subnet_ids != null ? 1 : 0
  name       = local.subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

resource "aws_redshift_parameter_group" "default" {
  name        = var.name
  description = "Hardened security for Redshift Clusters"
  family      = "redshift-1.0"
  tags        = var.tags

  parameter {
    name  = "enable_user_activity_logging"
    value = true
  }

  parameter {
    name  = "require_ssl"
    value = true
  }
}

module "logging_bucket" {
  count      = var.logging ? 1 : 0
  source     = "github.com/schubergphilis/terraform-aws-mcaf-s3?ref=v0.5.0"
  name       = var.logging_bucket
  policy     = data.aws_iam_policy_document.logging.json
  versioning = true
  tags       = var.tags
}

data "aws_redshift_service_account" "main" {}

data "aws_iam_policy_document" "logging" {
  statement {
    sid = "Put bucket policy needed for Redshift audit logging"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.logging_bucket}/*"
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
      "arn:aws:s3:::${var.logging_bucket}"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.main.arn]
    }
  }
}

resource "aws_redshift_cluster" "default" {
  cluster_identifier                  = var.name
  database_name                       = var.database
  master_username                     = var.username
  master_password                     = var.password
  allow_version_upgrade               = true
  automated_snapshot_retention_period = var.automated_snapshot_retention_period
  cluster_parameter_group_name        = aws_redshift_parameter_group.default.name
  cluster_subnet_group_name           = local.subnet_group_name
  cluster_type                        = var.cluster_type
  elastic_ip                          = local.elastic_ip
  encrypted                           = true
  enhanced_vpc_routing                = var.enhanced_vpc_routing
  final_snapshot_identifier           = var.final_snapshot_identifier
  iam_roles                           = var.iam_roles
  kms_key_id                          = var.kms_key_arn
  node_type                           = var.node_type
  number_of_nodes                     = var.number_of_nodes
  publicly_accessible                 = var.publicly_accessible
  skip_final_snapshot                 = var.skip_final_snapshot
  vpc_security_group_ids              = [aws_security_group.default.id]
  tags                                = var.tags

  logging {
    enable        = var.logging
    bucket_name   = module.logging_bucket[0].name
    s3_key_prefix = "redshift-audit-logs/"
  }
}
