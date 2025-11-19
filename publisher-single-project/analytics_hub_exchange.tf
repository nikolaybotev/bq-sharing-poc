# BigQuery Sharing Data Exchange in bq-publisher project
resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  project          = google_project.bq_publisher.project_id
  location         = var.region
  data_exchange_id = "data_exchange"
  display_name     = "Data Exchange"
  description      = "BigQuery data sharing exchange"

  depends_on = [
    google_project_service.analyticshub_publisher
  ]
}
