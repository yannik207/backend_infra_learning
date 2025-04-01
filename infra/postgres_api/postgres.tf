resource "kubernetes_namespace" "test_namespace" {
  metadata {
    name = "yannik-test-namespace"
    labels = {
      environment = "dev"
      managed-by = "terraform"
    }
  }
}

resource "kubernetes_service" "postgres-service" {
    metadata {
      name = "yannik-postgres-svc"
      namespace = kubernetes_namespace.test_namespace.metadata[0].name
    }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port       = 5432          # Port on which the service will be exposed
      target_port = 5432         # Port on the pod to which traffic will be directed
      protocol   = "TCP"         # Protocol (TCP is common for Postgres)
    }

    type = "ClusterIP"            # You can also set this to LoadBalancer or NodePort if required
  }
  
}

resource "kubernetes_persistent_volume_claim" "pg-volume" {
    metadata {
        name = "postgres-volume"
        namespace = kubernetes_namespace.test_namespace.metadata[0].name
    }
    spec {
        access_modes = ["ReadWriteOnce"]
        resources {
            requests = {
                storage = "8Gi"
                }
            }
    storage_class_name = "standard"
    }
}

resource "kubernetes_stateful_set" "postgres-stateful" {
  metadata {
    name = "postgres"
    namespace = kubernetes_namespace.test_namespace.metadata[0].name
    labels = {
      app = "postgres"
      tier = "backend"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        # You need to add this labels block
        labels = {
          app = "postgres"
        }
        # The name field here is actually not used by StatefulSets
        # and can safely be removed
      }
      spec {
        container {
          name = "postgres"
          image = "postgres:latest"

          env {
            name = "POSTGRES_PASSWORD"
            value = var.postgres_password
          }

         env {
            name = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }
          
          volume_mount {
            name = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
            name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.pg-volume.metadata[0].name
          }
        }
      }
    }
    service_name = kubernetes_service.postgres-service.metadata[0].name
  }
}

resource "kubernetes_deployment" "pgadmin-deployment" {
  metadata {
    name = "pgadmin"
    namespace = kubernetes_namespace.test_namespace.metadata[0].name
    labels = {
      app = "postgres"
      environment = "dev"
      tier = "fronted"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "postgres"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }
      spec {
        container {
          name = "pg-admin-container"
          image = "dpage/pgadmin4"

          env {
            name = "PGADMIN_DEFAULT_EMAIL"
            value = var.admin_mail
          }
        
          env {
            name = "PGADMIN_DEFAULT_PASSWORD"
            value = var.admin_password
          }
        }
      }
    }

  }
}

resource "kubernetes_service" "pgadmin-service" {
  metadata {
    name = "pgadmin-service"
    namespace = kubernetes_namespace.test_namespace.metadata[0].name
  }
  spec {
    selector = {
      app = "pgadmin"
    }
    port {
      port = 5050
      target_port = 80
      protocol = "TCP"
    }
    type = "ClusterIP"
  }
}
