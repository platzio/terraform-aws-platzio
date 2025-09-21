resource "kubernetes_namespace" "this" {
  metadata {
    name = var.k8s_namespace
  }
}

resource "helm_release" "this" {
  depends_on = [
    kubernetes_namespace.this,
    kubernetes_secret.oidc_config,
    kubernetes_secret.database_config,
  ]

  name       = var.helm_release_name
  namespace  = var.k8s_namespace
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version

  values = [templatefile("${path.module}/values.yaml", {
    ingress         = var.ingress
    admin_emails    = var.admin_emails
    chart_discovery = var.chart_discovery
    k8s_agents      = var.k8s_agents
    node_selector   = var.node_selector
    backup          = var.backup
  })]
}
