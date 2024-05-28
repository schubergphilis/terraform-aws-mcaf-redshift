# terraform-aws-mcaf-redshift

Terraform module to setup and manage an AWS Redshift cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logging_bucket"></a> [logging\_bucket](#module\_logging\_bucket) | github.com/schubergphilis/terraform-aws-mcaf-s3 | v0.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_redshift_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster) | resource |
| [aws_redshift_logging.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_logging) | resource |
| [aws_redshift_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_parameter_group) | resource |
| [aws_redshift_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database"></a> [database](#input\_database) | The name of the first database to be created when the cluster is created | `string` | n/a | yes |
| <a name="input_ingress_cidr_blocks"></a> [ingress\_cidr\_blocks](#input\_ingress\_cidr\_blocks) | List of CIDR blocks that should be allowed access to the Redshift cluster | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to identify the cluster by | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the cluster | `map(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_additional_egress_rules"></a> [additional\_egress\_rules](#input\_additional\_egress\_rules) | n/a | <pre>list(object({<br>    description        = string<br>    from_port          = number<br>    to_port            = number<br>    protocol           = string<br>    security_group_ids = list(string)<br>    prefix_list_ids    = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_ingress_rules"></a> [additional\_ingress\_rules](#input\_additional\_ingress\_rules) | n/a | <pre>list(object({<br>    description        = string<br>    from_port          = number<br>    to_port            = number<br>    protocol           = string<br>    security_group_ids = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_automated_snapshot_retention_period"></a> [automated\_snapshot\_retention\_period](#input\_automated\_snapshot\_retention\_period) | The number of days automated snapshots should be retained | `number` | `1` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | The cluster type to use (either `single-node` or `multi-node`) | `string` | `"single-node"` | no |
| <a name="input_egress_cidr_blocks"></a> [egress\_cidr\_blocks](#input\_egress\_cidr\_blocks) | List of CIDR blocks that should be allowed access from the Redshift cluster | `list(string)` | `[]` | no |
| <a name="input_enhanced_vpc_routing"></a> [enhanced\_vpc\_routing](#input\_enhanced\_vpc\_routing) | If true enhanced VPC routing is enabled | `bool` | `false` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Identifier of the final snapshot to create before deleting the cluster | `string` | `"none"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all logging should be deleted when deleting the cluster | `bool` | `false` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | A list of IAM Role ARNs to associate with the cluster | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key to encrypt the Redshift cluster | `string` | `null` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration | <pre>object({<br>    bucket_lifecycle_rule = optional(any, [])<br>    bucket_name           = optional(string, null)<br>    bucket_prefix         = optional(string, "redshift-audit-logs/")<br>    create_bucket         = optional(bool, true)<br>    log_destination_type  = string<br>    log_exports           = optional(list(string), ["connectionlog", "useractivitylog", "userlog"])<br>  })</pre> | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The node type to be provisioned for the cluster | `string` | `"dc2.large"` | no |
| <a name="input_number_of_nodes"></a> [number\_of\_nodes](#input\_number\_of\_nodes) | The number of compute nodes in the cluster | `number` | `1` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether or not the Redshift cluster will be publicly accessible | `bool` | `false` | no |
| <a name="input_redshift_subnet_group"></a> [redshift\_subnet\_group](#input\_redshift\_subnet\_group) | Name of Redshift subnet group the cluster should be attached to | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final snapshot is created before deleting the cluster | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to deploy Redshift in | `list(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to deploy Redshift in | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_identifier"></a> [cluster\_identifier](#output\_cluster\_identifier) | The cluster identifier |
| <a name="output_cluster_nodes"></a> [cluster\_nodes](#output\_cluster\_nodes) | The nodes in the redshift cluster |
| <a name="output_database"></a> [database](#output\_database) | The name of the default database in the cluster |
| <a name="output_elastic_ip"></a> [elastic\_ip](#output\_elastic\_ip) | The Elastic IP (EIP) address for the cluster |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The connection endpoint |
| <a name="output_id"></a> [id](#output\_id) | The Redshift cluster ID |
| <a name="output_port"></a> [port](#output\_port) | The port the cluster responds on |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group associated with the cluster |
| <a name="output_username"></a> [username](#output\_username) | Username for the master DB user |
<!-- END_TF_DOCS -->
