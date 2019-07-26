locals {
  bucket     = "${var.stack}-logging"
  subnet_ids = length(var.subnet_ids) > 0 ? var.subnet_ids : aws_subnet.public[*].id
  vpc_id     = data.aws_subnet.selected.vpc_id
}

data aws_subnet selected {
  id = local.subnet_ids[0]
}

resource aws_eip redshift {
  vpc  = true
  tags = merge(var.tags, map("Name", "${var.stack}-redshift"))
}

resource aws_security_group default {
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

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_redshift_subnet_group default {
  name       = var.stack
  subnet_ids = local.subnet_ids
  tags       = var.tags
}

resource aws_redshift_parameter_group default {
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

resource aws_s3_bucket logging {
  count         = var.logging ? 1 : 0
  bucket        = local.bucket
  policy        = data.aws_iam_policy_document.logging.json
  force_destroy = var.force_destroy
  tags          = var.tags

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_id
        sse_algorithm     = var.sse_algorithm
      }
    }
  }
}
data aws_redshift_service_account main {}

data aws_iam_policy_document logging {
  statement {
    sid       = "Put bucket policy needed for Redshift audit logging"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.bucket}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.main.arn]
    }
  }

  statement {
    sid       = "Get ACL bucket policy needed for Redshift audit logging"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.bucket}"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_redshift_service_account.main.arn]
    }
  }
}

resource aws_redshift_cluster default {
  cluster_identifier                  = var.stack
  database_name                       = var.database
  master_username                     = var.username
  master_password                     = var.password
  node_type                           = var.node_type
  cluster_type                        = var.cluster_type
  number_of_nodes                     = var.number_of_nodes
  allow_version_upgrade               = true
  automated_snapshot_retention_period = 1
  cluster_parameter_group_name        = aws_redshift_parameter_group.default.name
  cluster_subnet_group_name           = aws_redshift_subnet_group.default.name
  iam_roles                           = var.iam_roles
  elastic_ip                          = aws_eip.redshift.public_ip
  skip_final_snapshot                 = var.skip_final_snapshot
  final_snapshot_identifier           = var.final_snapshot_identifier
  encrypted                           = true
  publicly_accessible                 = true
  vpc_security_group_ids              = [aws_security_group.default.id]
  tags                                = var.tags

  logging {
    enable        = var.logging
    bucket_name   = aws_s3_bucket.logging[0].id
    s3_key_prefix = "redshift-audit-logs/"
  }
}
