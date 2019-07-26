variable stack {
  type        = string
  description = "The stack name for the Redshift Cluster"
}

variable database {
  type        = string
  description = "The name of the first database to be created when the cluster is created"
}

variable username {
  type        = string
  description = "Username for the master DB user"
}

variable password {
  type        = string
  description = "Password for the master DB user"
}

variable node_type {
  type        = string
  default     = "dc2.large"
  description = "The node type to be provisioned for the cluster"
}

variable cluster_type {
  type        = string
  default     = "single-node"
  description = "The cluster type to use (either `single-node` or `multi-node`)"
}

variable number_of_nodes {
  type        = number
  default     = 1
  description = "The number of compute nodes in the cluster"
}

variable iam_roles {
  type        = list(string)
  default     = []
  description = "A list of IAM Role ARNs to associate with the cluster"
}

variable cidr_blocks {
  type        = list(string)
  description = "List of CIDR blocks that should be allowed access to the Redshift cluster"
}

variable availability_zones {
  type        = list(string)
  default     = []
  description = "List of availability zones to deploy Redshift in"
}

variable subnet_ids {
  type        = list(string)
  default     = []
  description = "List of subnet IDs to deploy Redshift in"
}

variable logging {
  type        = bool
  default     = true
  description = "Enables logging information such as queries and connection attempts"
}

variable kms_key_id {
  type        = string
  default     = ""
  description = "The AWS KMS key ID used for the `SSE-KMS` encryption"
}

variable sse_algorithm {
  type        = string
  default     = "aws:kms"
  description = "The server-side encryption algorithm to use, defaults to `aws:kms`"
}

variable force_destroy {
  type        = bool
  default     = false
  description = "A boolean that indicates all logging should be deleted when deleting the cluster"
}

variable skip_final_snapshot {
  type        = bool
  default     = false
  description = "Determines whether a final snapshot is created before deleting the cluster"
}

variable final_snapshot_identifier {
  type        = string
  default     = "none"
  description = "Identifier of the final snapshot to create before deleting the cluster"
}

variable tags {
  type        = map(string)
  description = "A mapping of tags to assign to the bucket"
}
