output "instance_name" {
  description = "instance_name as passed to this module"
  value       = var.instance_name
}

output "iam_role_arn" {
  description = "IAM role ARN to use with k8s-agent worker"
  value       = aws_iam_role.this.arn
}
