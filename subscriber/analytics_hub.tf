# BigQuery Analytics Hub Listing Subscription
resource "google_bigquery_analytics_hub_listing_subscription" "data_subscription" {
  project          = var.exchange_project_id
  location         = var.region
  data_exchange_id = var.data_exchange_id
  listing_id       = var.listing_id

  destination_dataset {
    location      = var.region
    friendly_name = "Data Subscription"
    description   = "Subscription to shared BigQuery dataset"

    dataset_reference {
      dataset_id = "data_subscription"
      project_id = google_project.bq_subscriber.project_id
    }
  }

  depends_on = [
    google_project_service.bigquery_subscriber,
    google_project_service.analyticshub_subscriber
  ]
}

