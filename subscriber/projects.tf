# Project: bq-subscriber
resource "google_project" "bq_subscriber" {
  name            = "${var.project_prefix}-bq-subscriber"
  project_id      = "${var.project_prefix}-bq-subscriber"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

# Enable BigQuery API
resource "google_project_service" "bigquery_subscriber" {
  project = google_project.bq_subscriber.project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = false
}

# Enable Analytics Hub API
resource "google_project_service" "analyticshub_subscriber" {
  project = google_project.bq_subscriber.project_id
  service = "analyticshub.googleapis.com"

  disable_dependent_services = false
}
