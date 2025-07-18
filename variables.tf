variable "automated_snapshot_retention_period" {
  type        = number
  default     = 1
  description = "The number of days automated snapshots should be retained"
}

variable "cluster_type" {
  type        = string
  default     = "single-node"
  description = "The cluster type to use (either `single-node` or `multi-node`)"
}

variable "database" {
  type        = string
  description = "The name of the first database to be created when the cluster is created"
}

variable "enhanced_vpc_routing" {
  type        = bool
  default     = false
  description = "If true enhanced VPC routing is enabled"
}

variable "final_snapshot_identifier" {
  type        = string
  default     = "none"
  description = "Identifier of the final snapshot to create before deleting the cluster"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "A boolean that indicates all logging should be deleted when deleting the cluster"
}

variable "iam_roles" {
  type        = list(string)
  default     = []
  description = "A list of IAM Role ARNs to associate with the cluster"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN for the KMS encryption key to encrypt the Redshift cluster"
}

variable "logging" {
  type = object({
    create_bucket         = optional(bool, true)
    bucket_lifecycle_rule = optional(any, [])
    bucket_name           = optional(string)
    bucket_prefix         = optional(string, "redshift-audit-logs/")
    log_destination_type  = string
    log_exports           = optional(list(string), ["connectionlog", "useractivitylog", "userlog"])
  })
  default     = null
  description = <<-EOT
    Logging configuration for Redshift cluster.
    
    `bucket_lifecycle_rule`: List of lifecycle configuration settings for the logging S3 bucket.
    See https://github.com/schubergphilis/terraform-aws-mcaf-s3 for complete structure.
    Passed directly to the S3 module's `lifecycle_rule` variable.
  EOT

  validation {
    condition     = var.logging == null ? true : contains(["s3", "cloudwatch"], var.logging.log_destination_type)
    error_message = "Valid values are \"s3\" or \"cloudwatch\"."
  }

  validation {
    condition     = var.logging == null ? true : (var.logging.log_destination_type == "s3" ? var.logging.bucket_name != null : true)
    error_message = "\"bucket_name\" must be provided when log_destination_type is \"s3\"."
  }
}

variable "maintenance_track_name" {
  type        = string
  default     = "current"
  description = "The name of the maintenance track to apply to the cluster."
}

variable "name" {
  type        = string
  description = "The name to identify the cluster by"
}

variable "number_of_nodes" {
  type        = number
  default     = 1
  description = "The number of compute nodes in the cluster"
}

variable "node_type" {
  type        = string
  default     = "dc2.large"
  description = "The node type to be provisioned for the cluster"
}

variable "password" {
  type        = string
  description = "Password for the master DB user"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether or not the Redshift cluster will be publicly accessible"
}

variable "redshift_subnet_group" {
  type        = string
  default     = null
  description = "Name of Redshift subnet group the cluster should be attached to"
}

variable "security_group_egress_rules" {
  type = list(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = string
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "-1")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    to_port                      = optional(number)
  }))
  default     = []
  description = "Security Group egress rules"

  validation {
    condition     = alltrue([for r in var.security_group_egress_rules : (r.cidr_ipv4 != null || r.cidr_ipv6 != null || r.prefix_list_id != null || r.referenced_security_group_id != null)])
    error_message = "Although \"cidr_ipv4\", \"cidr_ipv6\", \"prefix_list_id\", and \"referenced_security_group_id\" are all marked as optional, you must provide one of them in order to configure the destination of the traffic."
  }
}

variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "The security group(s) for running the Redshift cluster within the VPC. If not specified a default SG will be created"
}

variable "security_group_ingress_rules" {
  type = list(object({
    cidr_ipv4                    = optional(string)
    cidr_ipv6                    = optional(string)
    description                  = string
    from_port                    = optional(number)
    ip_protocol                  = optional(string, "-1")
    prefix_list_id               = optional(string)
    referenced_security_group_id = optional(string)
    to_port                      = optional(number)
  }))
  default     = []
  description = "Security Group ingress rules"

  validation {
    condition     = alltrue([for r in var.security_group_ingress_rules : (r.cidr_ipv4 != null || r.cidr_ipv6 != null || r.prefix_list_id != null || r.referenced_security_group_id != null)])
    error_message = "Although \"cidr_ipv4\", \"cidr_ipv6\", \"prefix_list_id\", and \"referenced_security_group_id\" are all marked as optional, you must provide one of them in order to configure the destination of the traffic."
  }
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Determines whether a final snapshot is created before deleting the cluster"
}

variable "subnet_ids" {
  type        = list(string)
  default     = null
  description = "List of subnet IDs to deploy Redshift in"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the cluster"
}

variable "username" {
  type        = string
  description = "Username for the master DB user"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "ID of the VPC to deploy Redshift in"
}
