resource "kubernetes_namespace" "this" {
  count = var.create_namespace == true ? 1 : 0

  metadata {
    name = var.k8s_namespace
  }
}

resource "helm_release" "this" {
  depends_on = [
    kubernetes_namespace.this,
    kubernetes_secret.oidc_config,
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
    use_chart_db    = var.use_chart_db
    db_url_override = var.db_url_override
  })]
}
