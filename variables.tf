variable "name" {
  type        = string
  description = "The name to identify the cluster by"
}

variable "database" {
  type        = string
  description = "The name of the first database to be created when the cluster is created"
}

variable "username" {
  type        = string
  description = "Username for the master DB user"
}

variable "password" {
  type        = string
  description = "Password for the master DB user"
}

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "List of availability zones to deploy Redshift in"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks that should be allowed access to the Redshift cluster"
}

variable "cluster_type" {
  type        = string
  default     = "single-node"
  description = "The cluster type to use (either `single-node` or `multi-node`)"
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

variable "logging" {
  type        = bool
  default     = true
  description = "Enables logging information such as queries and connection attempts"
}

variable "logging_bucket" {
  type        = string
  description = "Name of the S3 bucket to write logging information to"
}

variable "iam_roles" {
  type        = list(string)
  default     = []
  description = "A list of IAM Role ARNs to associate with the cluster"
}

variable "node_type" {
  type        = string
  default     = "dc2.large"
  description = "The node type to be provisioned for the cluster"
}

variable "number_of_nodes" {
  type        = number
  default     = 1
  description = "The number of compute nodes in the cluster"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether or not the Redshift cluster will be publicly accessible"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Determines whether a final snapshot is created before deleting the cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to deploy Redshift in"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to deploy Redshift in"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the cluster"
}
