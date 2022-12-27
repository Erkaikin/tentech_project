output "rds_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.db.endpoint
}