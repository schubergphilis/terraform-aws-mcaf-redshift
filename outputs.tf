output "id" {
  value       = aws_redshift_cluster.default.id
  description = "The Redshift cluster ID"
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

output "username" {
  value       = var.username
  description = "Username for the master DB user"
}

output "port" {
  value       = aws_redshift_cluster.default.port
  description = "The port the cluster responds on"
}

output "security_group_id" {
  value       = aws_security_group.default.id
  description = "The ID of the security group associated with the cluster"
}
