output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "app_url" {
  value = "https://${var.subdomain}"
}

output "s3_bucket_name" {
  value = aws_s3_bucket.project_bucket.bucket
}
output "ec2_instance_id" {
  value = aws_instance.main.id
}