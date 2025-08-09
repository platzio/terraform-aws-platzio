variable "k8s_cluster_name" {
  description = "Name of EKS cluster, used for getting credentials"
  type        = string
}

variable "k8s_namespace" {
  description = "Kubernetes namespace name, also used as prefix for AWS resources"
  type        = string
  default     = "platz"
}

variable "create_namespace" {
  description = "Whether to create the namespace passed in the k8s_namespace variable"
  type        = bool
  default     = true
}

variable "depends_on_value" {
  description = "Arbitrary value to pass down to the module to force its dependency on other resources for proper destruction order"
  type        = string
  default     = ""
}

variable "helm_release_name" {
  description = "The name of the Helm release"
  default     = "platz"
}

variable "chart_version" {
  description = "Helm chart version to install/upgrade"
  type        = string
  default     = "0.6.0"
}

variable "ingress" {
  description = "Chart ingress settings, if missing an ingress won't be created"
  type = object({
    host       = string
    class_name = string
    tls = object({
      secret_name        = string
      create_certificate = bool
      create_issuer      = bool
      issuer_email       = string
    })
  })
  default = null
}

variable "oidc_ssm_params" {
  description = "SSM parameter names for configuring OIDC authentication"
  type = object({
    server_url    = string
    client_id     = string
    client_secret = string
  })
}

variable "admin_emails" {
  description = "Email addresses to add as admins instead of regular users. This option is useful for allowing the first admins to log into Platz on a fresh deployment. Note that admins are added only after successful validation against the OIDC server, and if a user doesn't exist with that email. This means that if an admin is later changed to a regular user role, they will never become an admin again unless their user is deleted from the database, or removed from this option."
  type        = list(string)
  default     = []
}

variable "use_chart_db" {
  description = "Use the postgresql sub-chart for deploying a database"
  type        = bool
  default     = true
}

variable "db_url_override" {
  description = "Provide an override URL for the database (set use_chart_db=false if using this variable)"
  type        = string
  default     = ""
}

variable "chart_discovery" {
  description = "A list of SQS queues and IAM roles for discovering charts in ECR. This variable should use the outputs of the chart-discovery terraform modules"
  default     = []
  type = list(object({
    instance_name     = string
    enable_tag_parser = bool
    iam_role_arn      = string
    queue_name        = string
    queue_region      = string
  }))
}

variable "k8s_agents" {
  description = "A list of IAM roles, once for each k8s-agent to run. Each list item of this variable should use the outputs of the k8s-agent-role terraform module"
  type = list(object({
    instance_name = string
    iam_role_arn  = string
  }))
}

variable "repository" {
  description = "Helm chart url to install"
  type        = string
  default     = "https://platzio.github.io/helm-charts"
}

variable "chart" {
  description = "Helm chart name"
  type        = string
  default     = "platzio"
}

variable "node_selector" {
  description = "Node selector"
  type = object({
    key   = string
    value = string
  })
  default = null
}

variable "backup" {
  description = "Details for database backup, enables an hourly cronjob for backing up the database"
  type = object({
    bucket_name   = string
    bucket_region = string
    bucket_prefix = string
    iam_role_arn  = string
  })
  default = null
}
