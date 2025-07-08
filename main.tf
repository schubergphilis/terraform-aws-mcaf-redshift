locals {
  create_logging_bucket = try(var.logging.create_bucket, false) && try(var.logging.log_destination_type, "") == "s3" ? true : false
  elastic_ip            = var.publicly_accessible ? aws_eip.default[0].public_ip : null
  subnet_group_name     = var.subnet_ids == null ? "default" : (var.redshift_subnet_group != null ? var.redshift_subnet_group : var.name)
}

resource "aws_eip" "default" {
  #checkov:skip=CKV2_AWS_19:The EIP is created conditionally based on the publicly_accessible variable and attached to the cluster
  count = var.publicly_accessible ? 1 : 0

  domain = "vpc"
  tags   = merge(var.tags, { "Name" = "redshift-${var.name}" })
}

resource "aws_security_group" "default" {
  #checkov:skip=CKV2_AWS_5:Security group is conditionally attached to Redshift cluster when no existing security groups are provided
  count = var.subnet_ids != null && length(var.security_group_ids) == 0 ? 1 : 0

  name        = "redshift-${var.name}"
  description = "Access to Redshift"
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_vpc_security_group_egress_rule" "default" {
  for_each = var.subnet_ids != null && length(var.security_group_ids) == 0 && length(var.security_group_egress_rules) != 0 ? { for v in var.security_group_egress_rules : v.description => v } : {}

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  security_group_id            = aws_security_group.default[0].id
  to_port                      = each.value.to_port
  tags                         = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "default" {
  for_each = var.subnet_ids != null && length(var.security_group_ids) == 0 && length(var.security_group_ingress_rules) != 0 ? { for v in var.security_group_ingress_rules : v.description => v } : {}

  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  description                  = each.value.description
  from_port                    = each.value.from_port
  ip_protocol                  = each.value.ip_protocol
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
  security_group_id            = aws_security_group.default[0].id
  to_port                      = each.value.to_port
  tags                         = var.tags
}

resource "aws_redshift_subnet_group" "default" {
  count = var.subnet_ids != null ? 1 : 0

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

data "aws_iam_policy_document" "logging" {
  count = local.create_logging_bucket ? 1 : 0

  statement {
    sid = "Put bucket policy needed for Redshift audit logging"
    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl",
    ]
    resources = [
      "arn:aws:s3:::${var.logging.bucket_name}",
      "arn:aws:s3:::${var.logging.bucket_name}/*",
    ]
    principals {
      type        = "Service"
      identifiers = ["redshift.amazonaws.com"]
    }
  }
}

module "logging_bucket" {
  count = local.create_logging_bucket ? 1 : 0

  source  = "schubergphilis/mcaf-s3/aws"
  version = "~> 1.5"

  name           = var.logging.bucket_name
  force_destroy  = var.force_destroy
  policy         = data.aws_iam_policy_document.logging[0].json
  lifecycle_rule = var.logging.bucket_lifecycle_rule
  versioning     = true
  tags           = var.tags
}

resource "aws_redshift_cluster" "default" {
  #checkov:skip=CKV_AWS_71: Logging is enabled using the aws_redshift_logging resource
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
  #checkov:skip=CKV_AWS_321:User defined
  enhanced_vpc_routing      = var.enhanced_vpc_routing
  final_snapshot_identifier = var.final_snapshot_identifier
  iam_roles                 = var.iam_roles
  kms_key_id                = var.kms_key_arn
  maintenance_track_name    = var.maintenance_track_name
  node_type                 = var.node_type
  number_of_nodes           = var.number_of_nodes
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = var.skip_final_snapshot
  vpc_security_group_ids    = var.subnet_ids != null && length(var.security_group_ids) == 0 ? [aws_security_group.default[0].id] : var.security_group_ids
  tags                      = var.tags
}

resource "aws_redshift_logging" "default" {
  count = var.logging != null ? 1 : 0

  cluster_identifier   = aws_redshift_cluster.default.id
  bucket_name          = local.create_logging_bucket ? module.logging_bucket[0].name : var.logging.bucket_name
  log_destination_type = var.logging.log_destination_type
  log_exports          = var.logging.log_destination_type == "cloudwatch" ? var.logging.log_exports : null
  s3_key_prefix        = var.logging.log_destination_type == "s3" ? var.logging.bucket_prefix : null
}
