output "id" {
  value       = aws_redshift_cluster.default.id
  description = "The Redshift cluster ID"
}

output "cluster_identifier" {
  value       = aws_redshift_cluster.default.cluster_identifier
  description = "The cluster identifier"
}

output "cluster_nodes" {
  value       = aws_redshift_cluster.default.cluster_nodes
  description = "The nodes in the redshift cluster"
}

output "database" {
  value       = var.database
  description = "The name of the default database in the cluster"
}

output "elastic_ip" {
  value       = aws_redshift_cluster.default.elastic_ip
  description = "The Elastic IP (EIP) address for the cluster"
}

output "endpoint" {
  value       = aws_redshift_cluster.default.endpoint
  description = "The connection endpoint"
}

output "port" {
  value       = aws_redshift_cluster.default.port
  description = "The port the cluster responds on"
}

output "security_group_id" {
  value       = try(aws_security_group.default[0].id, "")
  description = "The ID of the security group associated with the cluster"
}

output "username" {
  value       = var.username
  description = "Username for the master DB user"
}
