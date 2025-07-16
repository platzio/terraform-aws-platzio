output "instance_name" {
  description = "instance_name as passed to this module"
  value       = var.instance_name
}

output "iam_role_arn" {
  description = "IAM role ARN to use with chart-discovery worker"
  value       = aws_iam_role.this.arn
}

output "queue_name" {
  description = "Name of SQS queue receiving ECR notifications"
  value       = aws_sqs_queue.this.name
}

output "queue_region" {
  description = "AWS region of the SQS queue"
  value       = data.aws_region.current.region
}

output "enable_tag_parser" {
  description = "The enable_tag_parser variable as passed to this module"
  value       = var.enable_tag_parser
}
