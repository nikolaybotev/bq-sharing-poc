# BigQuery Sharing Data Exchange in bq-exchange project
resource "google_bigquery_analytics_hub_data_exchange" "data_exchange" {
  project          = google_project.bq_exchange.project_id
  location         = var.location
  data_exchange_id = var.exchange_id
  display_name     = var.exchange_display_name
  description      = var.exchange_description

  depends_on = [
    google_project_service.analyticshub_exchange
  ]
}

# BigQuery Sharing Listing in bq-exchange project
resource "google_bigquery_analytics_hub_listing" "data_listing" {
  project          = google_project.bq_exchange.project_id
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
  listing_id       = var.listing_id
  display_name     = var.listing_display_name
  description      = var.listing_description

  bigquery_dataset {
    dataset = google_bigquery_dataset.shared_dataset.id
  }

  publisher {
    name = var.data_provider_name
  }

  data_provider {
    name            = var.data_provider_name
    primary_contact = var.primary_contact
  }

  depends_on = [
    google_bigquery_analytics_hub_data_exchange.data_exchange,
    google_bigquery_dataset.shared_dataset
  ]
}

# IAM policy to allow bq-subscriber project to subscribe to the listing
# Grant permission at the listing level for the entire subscriber project
resource "google_bigquery_analytics_hub_listing_iam_member" "subscriber_access" {
  project          = google_project.bq_exchange.project_id
  location         = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.data_listing.listing_id
  role             = "roles/bigquery.analyticsHubSubscriber"
  # Grant access to the entire subscriber project
  member = "project:${google_project.bq_subscriber.project_id}"

  depends_on = [
    google_bigquery_analytics_hub_listing.data_listing
  ]
}

# Also grant project-level access for the subscriber project
resource "google_project_iam_member" "subscriber_analyticshub_subscriber" {
  project = google_project.bq_exchange.project_id
  role    = "roles/bigquery.analyticsHubSubscriber"
  # Grant access to the entire subscriber project
  member = "project:${google_project.bq_subscriber.project_id}"

  depends_on = [
    google_bigquery_analytics_hub_listing.data_listing
  ]
}

# BigQuery Sharing Subscription in bq-subscriber project
resource "google_bigquery_analytics_hub_listing_subscription" "data_subscription" {
  project         = google_project.bq_subscriber.project_id
  location        = var.location
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
  listing_id      = google_bigquery_analytics_hub_listing.data_listing.listing_id

  destination_dataset {
    location = var.location
    dataset_reference {
      dataset_id = var.subscription_id
      project_id = google_project.bq_subscriber.project_id
    }
  }

  depends_on = [
    google_bigquery_analytics_hub_listing.data_listing,
    google_bigquery_analytics_hub_listing_iam_member.subscriber_access,
    google_project_service.analyticshub_subscriber
  ]
}

