# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v1.0.0

### Key Changes

- **Security Group Management Modernization**: Replaced legacy inline security group rules with dedicated `aws_vpc_security_group_*_rule` resources
- **Variable Restructuring**: Removed legacy security group variables and introduced new flexible rule variables
- **Enhanced Flexibility**: Added support for IPv4/IPv6 CIDR blocks, prefix lists, and security group references

#### Removed Variables

The following variables have been **removed**:

- `ingress_cidr_blocks` - Basic CIDR-based ingress rules
- `egress_cidr_blocks` - Basic CIDR-based egress rules
- `additional_ingress_rules` - Dynamic ingress rules
- `additional_egress_rules` - Dynamic egress rules

#### Added Variables

The following variables have been **added**:

- `security_group_ingress_rules` - Flexible ingress rules with support for multiple source types
- `security_group_egress_rules` - Flexible egress rules with support for multiple destination types
- `security_group_ids` - Option to use existing security groups instead of creating new ones

#### Migration Examples

**Before (v1.x):**

```hcl
module "redshift" {
  source = "schubergphilis/mcaf-redshift/aws"
  
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
}
```

**After (v1.x):**

```hcl
module "redshift" {
  source = "schubergphilis/mcaf-redshift/aws"
  
  security_group_egress_rules = [
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "All outbound traffic"
      ip_protocol = "-1"
    }
  ]

  security_group_ingress_rules = [
    {
      cidr_ipv4   = var.cidr_block
      description = "Allow inbound traffic from the VPC itself"
      from_port   = 5439
      to_port     = 5439
      ip_protocol = "tcp"
    },
    {
      cidr_ipv4   = "0.0.0.0/0"
      description = "All inbound traffic"
      ip_protocol = "-1"
    }
  ]
}
```

**Note**: Terraform does not automatically remove existing inline rules from a security group.

To avoid **duplicate rule errors** during `terraform apply`:

- Manually delete the existing rules from the security group (via the AWS Console or CLI)  
**OR**
- Use the `terraform import` command to bring existing rules into the Terraform state using their security group rule IDs.

Ensure that your configurations are updated accordingly before applying changes. 🚀
