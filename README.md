# terraform-aws-mcaf-redshift
Terraform module to setup and manage an AWS Redshift cluster

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0 |
| aws | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| database | The name of the first database to be created when the cluster is created | `string` | n/a | yes |
| ingress\_cidr\_blocks | List of CIDR blocks that should be allowed access to the Redshift cluster | `list(string)` | n/a | yes |
| logging\_bucket | Name of the S3 bucket to write logging information to | `string` | n/a | yes |
| name | The name to identify the cluster by | `string` | n/a | yes |
| password | Password for the master DB user | `string` | n/a | yes |
| tags | A mapping of tags to assign to the cluster | `map(string)` | n/a | yes |
| username | Username for the master DB user | `string` | n/a | yes |
| additional\_egress\_rules | n/a | <pre>list(object({<br>    description        = string<br>    from_port          = number<br>    to_port            = number<br>    protocol           = string<br>    security_group_ids = list(string)<br>    prefix_list_ids    = list(string)<br>  }))</pre> | `[]` | no |
| additional\_ingress\_rules | n/a | <pre>list(object({<br>    description        = string<br>    from_port          = number<br>    to_port            = number<br>    protocol           = string<br>    security_group_ids = list(string)<br>  }))</pre> | `[]` | no |
| automated\_snapshot\_retention\_period | The number of days automated snapshots should be retained | `number` | `1` | no |
| availability\_zones | List of availability zones to deploy Redshift in | `list(string)` | `[]` | no |
| cluster\_type | The cluster type to use (either `single-node` or `multi-node`) | `string` | `"single-node"` | no |
| egress\_cidr\_blocks | List of CIDR blocks that should be allowed access from the Redshift cluster | `list(string)` | `[]` | no |
| enhanced\_vpc\_routing | If true enhanced VPC routing is enabled | `bool` | `false` | no |
| final\_snapshot\_identifier | Identifier of the final snapshot to create before deleting the cluster | `string` | `"none"` | no |
| force\_destroy | A boolean that indicates all logging should be deleted when deleting the cluster | `bool` | `false` | no |
| iam\_roles | A list of IAM Role ARNs to associate with the cluster | `list(string)` | `[]` | no |
| kms\_key\_arn | The ARN for the KMS encryption key to encrypt the Redshift cluster | `string` | `null` | no |
| lifecycle\_rule | List of maps containing lifecycle management configuration settings | `any` | `[]` | no |
| logging | Enables logging information such as queries and connection attempts | `bool` | `true` | no |
| node\_type | The node type to be provisioned for the cluster | `string` | `"dc2.large"` | no |
| number\_of\_nodes | The number of compute nodes in the cluster | `number` | `1` | no |
| publicly\_accessible | Whether or not the Redshift cluster will be publicly accessible | `bool` | `false` | no |
| redshift\_subnet\_group | Name of Redshift subnet group the cluster should be attached to | `string` | `null` | no |
| skip\_final\_snapshot | Determines whether a final snapshot is created before deleting the cluster | `bool` | `false` | no |
| subnet\_ids | List of subnet IDs to deploy Redshift in | `list(string)` | `null` | no |
| vpc\_id | ID of the VPC to deploy Redshift in | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_identifier | The cluster identifier |
| database | The name of the default database in the cluster |
| elastic\_ip | The Elastic IP (EIP) address for the cluster |
| endpoint | The connection endpoint |
| id | The Redshift cluster ID |
| port | The port the cluster responds on |
| security\_group\_id | The ID of the security group associated with the cluster |
| username | Username for the master DB user |

<!--- END_TF_DOCS --->
