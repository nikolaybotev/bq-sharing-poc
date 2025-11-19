# IAM binding to grant Analytics Hub Subscriber role to a specific user
# See https://docs.cloud.google.com/bigquery/docs/analytics-hub-manage-listings#give_users_access_to_a_listing
resource "google_bigquery_analytics_hub_listing_iam_member" "user_subscriber" {
  project          = google_project.bq_exchange.project_id
  location         = var.region
  data_exchange_id = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
  listing_id       = google_bigquery_analytics_hub_listing.data_listing.listing_id
  role             = "roles/analyticshub.subscriber"
  member           = var.subscriber_principal

  depends_on = [
    google_bigquery_analytics_hub_listing.data_listing
  ]
}
