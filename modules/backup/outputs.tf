output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_region" {
  description = "S3 bucket region"
  value       = aws_s3_bucket.this.region
}

output "bucket_prefix" {
  description = "Prefix for backups as provided to this module"
  value       = var.bucket_prefix
}

output "iam_role_arn" {
  description = "IAM role ARN with permissions to PUT objects into the bucket"
  value       = aws_iam_role.this.arn
}
