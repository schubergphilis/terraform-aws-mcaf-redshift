output "id" {
  value       = aws_redshift_cluster.default.id
  description = "The Redshift Cluster ID"
}

output "database" {
  value       = var.database
  description = "The name of the default database in the Cluster"
}

output "username" {
  value       = var.username
  description = "Username for the master DB user"
}

output "endpoint" {
  value       = aws_redshift_cluster.default.endpoint
  description = "The connection endpoint"
}

output "port" {
  value       = aws_redshift_cluster.default.port
  description = "The Port the cluster responds on"
}

output "security_group_id" {
  value       = aws_security_group.default.id
  description = "The securitiry group id that is attached to the Redshift cluster"
}
