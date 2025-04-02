resource "kubernetes_deployment" "api" {
  metadata {
    name      = "fastpi"
    namespace = kubernetes_namespace.test_namespace.metadata[0].name
    labels = {
      app         = "api"
      environment = "dev"
      tier        = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "api"
      }
    }
    template {
      metadata {
        labels = {
          app = "api"
        }
      }
      spec {
        container {
          name  = "api"
          image = "${var.image}:${var.tag}"
        }
        service_account_name = kubernetes_service_account.kubernetes_admin.metadata[0].name
      }
    }
  }
}