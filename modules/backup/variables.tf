variable "name_prefix" {
  description = "Prefix to use for global resource names such as IAM roles"
  type        = string
  default     = "platz"
}

variable "k8s_namespace" {
  description = "Kubernetes namespace name where Platz is installed, possibly in another account. The namespace has to match the one used when installing Platz so that the backup job can perform AssumeRoleWithWebIdentity to the role created in this module."
  type        = string
  default     = "platz"
}

variable "irsa_oidc_provider" {
  description = "IRSA OIDC provider address, to be used in assume role documents"
  type        = string
}

variable "irsa_oidc_arn" {
  description = "IRSA OIDC provider ARN"
  type        = string
}

variable "bucket_name" {
  description = "Bucket name for backups"
  type        = string
}

variable "bucket_prefix" {
  description = "Prefix for storing backups"
  type        = string
  default     = ""
}
