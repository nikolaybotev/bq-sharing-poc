# BigQuery Sharing Listing in bq-publisher project
resource "google_bigquery_analytics_hub_listing" "data_listing" {
  project          = google_project.bq_publisher.project_id
  location         = var.region
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
