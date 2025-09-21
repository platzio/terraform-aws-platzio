locals {
  postgres_creds_secret_name = "postgres-creds"
  pg_user                    = "postgres"
  pg_database                = "postgres"
  postgres_pvc_name          = "postgres-data"
}

resource "random_password" "database_password" {
  length  = 25
  special = false
}

resource "kubernetes_persistent_volume_claim" "postgres_data" {
  metadata {
    name      = local.postgres_pvc_name
    namespace = var.k8s_namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "16Gi"
      }
    }
  }
}

resource "helm_release" "database" {
  count = var.install_database ? 1 : 0

  depends_on = [
    kubernetes_namespace.this,
    kubernetes_persistent_volume_claim.postgres_data,
  ]

  name       = "${var.helm_release_name}-postgres"
  namespace  = var.k8s_namespace
  repository = "https://groundhog2k.github.io/helm-charts/"
  chart      = "postgres"
  version    = "1.5.8"

  set = [
    {
      name  = "settings.authMethod"
      value = "password"
    },
    {
      name  = "storage.persistentVolumeClaimName"
      value = local.postgres_pvc_name
    },
    {
      name  = "settings.existingSecret"
      value = local.postgres_creds_secret_name
    },
    {
      name  = "settings.superuser.secretKey"
      value = "PGUSER"
    },
    {
      name  = "settings.superuserPassword.secretKey"
      value = "PGPASSWORD"
    },
  ]
}

resource "kubernetes_secret" "database_config" {
  depends_on = [
    kubernetes_namespace.this,
  ]

  metadata {
    name      = local.postgres_creds_secret_name
    namespace = var.k8s_namespace
  }

  data = {
    PGHOST     = var.install_database ? "${var.helm_release_name}-postgres.${var.k8s_namespace}.svc" : var.database_config.host
    PGPORT     = var.install_database ? "5432" : var.database_config.port
    PGUSER     = var.install_database ? local.pg_user : var.database_config.user
    PGPASSWORD = var.install_database ? random_password.database_password.result : var.database_config.password
    PGDATABASE = var.install_database ? local.pg_database : var.database_config.database
  }
}
