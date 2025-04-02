resource "google_service_account" "admin" {
  account_id   = "yannik-test-infra"
  display_name = "yannik infra test service account"
}

resource "google_project_iam_member" "owner_iam_role" {
  project = var.cloud_project
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.admin.member
}

resource "kubernetes_service_account" "kubernetes_admin" {
  depends_on = [kubernetes_namespace.test_namespace]
  metadata {
    name      = "yannik-infra-admin"
    namespace = kubernetes_namespace.test_namespace.metadata[0].name

    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.admin.email
    }
  }
}

resource "google_service_account_iam_binding" "gc_to_k8s" {
  depends_on         = [kubernetes_service_account.kubernetes_admin]
  service_account_id = "projects/${var.cloud_project}/serviceAccounts/${google_service_account.admin.email}"

  members = ["serviceAccount:${var.cloud_project}.svc.id.goog[${kubernetes_namespace.test_namespace.metadata[0].name}/${kubernetes_service_account.kubernetes_admin.metadata[0].name}]"]
  role    = "roles/iam.workloadIdentityUser"
}