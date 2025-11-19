# BigQuery Dataset in bq-publisher project
resource "google_bigquery_dataset" "shared_dataset" {
  project    = google_project.bq_publisher.project_id
  dataset_id = var.dataset_id
  location   = var.location

  description = "Dataset shared via BigQuery Sharing"

  depends_on = [
    google_project_service.bigquery_publisher
  ]
}

