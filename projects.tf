# Project: bq-publisher
resource "google_project" "bq_publisher" {
  name            = "${var.project_prefix}-bq-publisher"
  project_id      = "${var.project_prefix}-bq-publisher"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

# Project: bq-exchange
resource "google_project" "bq_exchange" {
  name            = "${var.project_prefix}-bq-exchange"
  project_id      = "${var.project_prefix}-bq-exchange"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

# Project: bq-subscriber
resource "google_project" "bq_subscriber" {
  name            = "${var.project_prefix}-bq-subscriber"
  project_id      = "${var.project_prefix}-bq-subscriber"
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

# Enable BigQuery API in all projects
resource "google_project_service" "bigquery_publisher" {
  project = google_project.bq_publisher.project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "bigquery_exchange" {
  project = google_project.bq_exchange.project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "bigquery_subscriber" {
  project = google_project.bq_subscriber.project_id
  service = "bigquery.googleapis.com"

  disable_dependent_services = false
}

# Enable Analytics Hub API in all projects
resource "google_project_service" "analyticshub_publisher" {
  project = google_project.bq_publisher.project_id
  service = "analyticshub.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "analyticshub_exchange" {
  project = google_project.bq_exchange.project_id
  service = "analyticshub.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "analyticshub_subscriber" {
  project = google_project.bq_subscriber.project_id
  service = "analyticshub.googleapis.com"

  disable_dependent_services = false
}

# Enable Access Context Manager API (required for VPC Service Controls)
resource "google_project_service" "accesscontextmanager_publisher" {
  project = google_project.bq_publisher.project_id
  service = "accesscontextmanager.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "accesscontextmanager_exchange" {
  project = google_project.bq_exchange.project_id
  service = "accesscontextmanager.googleapis.com"

  disable_dependent_services = false
}

# Enable Service Usage API (required for VPC Service Controls)
resource "google_project_service" "serviceusage_publisher" {
  project = google_project.bq_publisher.project_id
  service = "serviceusage.googleapis.com"

  disable_dependent_services = false
}

resource "google_project_service" "serviceusage_exchange" {
  project = google_project.bq_exchange.project_id
  service = "serviceusage.googleapis.com"

  disable_dependent_services = false
}
