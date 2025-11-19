# BigQuery Sharing Data Exchange in bq-exchange project
resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  project          = google_project.bq_exchange.project_id
  location         = var.location
  data_exchange_id = "data_exchange"
  display_name     = "Data Exchange"
  description      = "BigQuery data sharing exchange"

  depends_on = [
    google_project_service.analyticshub_exchange
  ]
}

# BigQuery Sharing Listing in bq-exchange project
resource "google_bigquery_analytics_hub_listing" "data_listing" {
  project          = google_project.bq_exchange.project_id
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
  listing_id       = "data_listing"
  display_name     = "Shared Dataset Listing"
  description      = "Shared BigQuery dataset"

  bigquery_dataset {
    dataset = google_bigquery_dataset.shared_dataset.id
  }

  publisher {
    name = "Data Provider"
  }

  data_provider {
    name            = "Data Provider"
    primary_contact = var.publisher_primary_contact
  }

  depends_on = [
    google_bigquery_analytics_hub_data_exchange.data_exchange,
    google_bigquery_dataset.shared_dataset
  ]
}
