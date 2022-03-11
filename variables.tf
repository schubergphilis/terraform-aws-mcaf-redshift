variable "additional_egress_rules" {
  type = list(object({
    description        = string
    from_port          = number
    to_port            = number
    protocol           = string
    security_group_ids = list(string)
    prefix_list_ids    = list(string)
  }))
  default = []
}

variable "additional_ingress_rules" {
  type = list(object({
    description        = string
    from_port          = number
    to_port            = number
    protocol           = string
    security_group_ids = list(string)
  }))
  default = []
}

variable "automated_snapshot_retention_period" {
  type        = number
  default     = 1
  description = "The number of days automated snapshots should be retained"
}

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "List of availability zones to deploy Redshift in"
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

variable "egress_cidr_blocks" {
  type        = list(string)
  default     = []
  description = "List of CIDR blocks that should be allowed access from the Redshift cluster"
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

variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks that should be allowed access to the Redshift cluster"
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "The ARN for the KMS encryption key to encrypt the Redshift cluster"
}

variable "logging" {
  type        = bool
  default     = true
  description = "Enables logging information such as queries and connection attempts"
}

variable "logging_bucket" {
  type        = string
  description = "Name of the S3 bucket to write logging information to"
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
