# https://www.terraform.io/docs/providers/random/r/id.html
provider "random" {
  version = "2.1.1"
}

resource "random_id" "entropy" {
  byte_length = 6
}

# https://www.terraform.io/docs/providers/google/r/google_service_account.html
resource "google_service_account" "default" {
  account_id   = "cluster-minimal-${random_id.entropy.hex}"
  display_name = "Minimal service account for GKE cluster ${var.cluster_name}"
  project      = var.gcp_project_id
}

# https://www.terraform.io/docs/providers/google/r/google_project_iam.html
resource "google_project_iam_member" "logging-log-writer" {
  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "monitoring-metric-writer" {
  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "monitoring-viewer" {
  role   = "roles/monitoring.viewer"
  member = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "storage-object-viewer" {
  count  = var.access_private_images == "true" ? 1 : 0
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.default.email}"
}
