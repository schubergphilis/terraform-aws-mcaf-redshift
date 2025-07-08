# terraform-aws-mcaf-redshift

Terraform module to setup and manage an AWS Redshift cluster.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.76.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_logging_bucket"></a> [logging\_bucket](#module\_logging\_bucket) | schubergphilis/mcaf-s3/aws | ~> 1.5 |

## Resources

| Name | Type |
|------|------|
| [aws_eip.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_redshift_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_cluster) | resource |
| [aws_redshift_logging.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_logging) | resource |
| [aws_redshift_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_parameter_group) | resource |
| [aws_redshift_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_iam_policy_document.logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database"></a> [database](#input\_database) | The name of the first database to be created when the cluster is created | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name to identify the cluster by | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_automated_snapshot_retention_period"></a> [automated\_snapshot\_retention\_period](#input\_automated\_snapshot\_retention\_period) | The number of days automated snapshots should be retained | `number` | `1` | no |
| <a name="input_cluster_type"></a> [cluster\_type](#input\_cluster\_type) | The cluster type to use (either `single-node` or `multi-node`) | `string` | `"single-node"` | no |
| <a name="input_enhanced_vpc_routing"></a> [enhanced\_vpc\_routing](#input\_enhanced\_vpc\_routing) | If true enhanced VPC routing is enabled | `bool` | `false` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | Identifier of the final snapshot to create before deleting the cluster | `string` | `"none"` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all logging should be deleted when deleting the cluster | `bool` | `false` | no |
| <a name="input_iam_roles"></a> [iam\_roles](#input\_iam\_roles) | A list of IAM Role ARNs to associate with the cluster | `list(string)` | `[]` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key to encrypt the Redshift cluster | `string` | `null` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging configuration for Redshift cluster.<br/><br/>`bucket_lifecycle_rule`: List of lifecycle configuration settings for the logging S3 bucket.<br/>See https://github.com/schubergphilis/terraform-aws-mcaf-s3 for complete structure.<br/>Passed directly to the S3 module's `lifecycle_rule` variable. | <pre>object({<br/>    create_bucket         = optional(bool, true)<br/>    bucket_lifecycle_rule = optional(any, [])<br/>    bucket_name           = optional(string)<br/>    bucket_prefix         = optional(string, "redshift-audit-logs/")<br/>    log_destination_type  = string<br/>    log_exports           = optional(list(string), ["connectionlog", "useractivitylog", "userlog"])<br/>  })</pre> | `null` | no |
| <a name="input_maintenance_track_name"></a> [maintenance\_track\_name](#input\_maintenance\_track\_name) | The name of the maintenance track to apply to the cluster. | `string` | `"current"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The node type to be provisioned for the cluster | `string` | `"dc2.large"` | no |
| <a name="input_number_of_nodes"></a> [number\_of\_nodes](#input\_number\_of\_nodes) | The number of compute nodes in the cluster | `number` | `1` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether or not the Redshift cluster will be publicly accessible | `bool` | `false` | no |
| <a name="input_redshift_subnet_group"></a> [redshift\_subnet\_group](#input\_redshift\_subnet\_group) | Name of Redshift subnet group the cluster should be attached to | `string` | `null` | no |
| <a name="input_security_group_egress_rules"></a> [security\_group\_egress\_rules](#input\_security\_group\_egress\_rules) | Security Group egress rules | <pre>list(object({<br/>    cidr_ipv4                    = optional(string)<br/>    cidr_ipv6                    = optional(string)<br/>    description                  = string<br/>    from_port                    = optional(number)<br/>    ip_protocol                  = optional(string, "-1")<br/>    prefix_list_id               = optional(string)<br/>    referenced_security_group_id = optional(string)<br/>    to_port                      = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The security group(s) for running the Redshift cluster within the VPC. If not specified a default SG will be created | `list(string)` | `[]` | no |
| <a name="input_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#input\_security\_group\_ingress\_rules) | Security Group ingress rules | <pre>list(object({<br/>    cidr_ipv4                    = optional(string)<br/>    cidr_ipv6                    = optional(string)<br/>    description                  = string<br/>    from_port                    = optional(number)<br/>    ip_protocol                  = optional(string, "-1")<br/>    prefix_list_id               = optional(string)<br/>    referenced_security_group_id = optional(string)<br/>    to_port                      = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final snapshot is created before deleting the cluster | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs to deploy Redshift in | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the cluster | `map(string)` | `{}` | no |
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
