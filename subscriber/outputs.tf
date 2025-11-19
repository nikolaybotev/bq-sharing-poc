output "bq_subscriber_project_id" {
  description = "Project ID for bq-subscriber"
  value       = google_project.bq_subscriber.project_id
}

output "bq_subscriber_project_number" {
  description = "Project number for bq-subscriber"
  value       = google_project.bq_subscriber.number
}

output "subscription_id" {
  description = "BigQuery Analytics Hub subscription ID"
  value       = google_bigquery_analytics_hub_listing_subscription.data_subscription.subscription_id
}

output "subscription_name" {
  description = "Full resource name of the subscription"
  value       = google_bigquery_analytics_hub_listing_subscription.data_subscription.name
}

output "linked_dataset_map" {
  description = "Map of listing resource names to associated linked datasets"
  value       = google_bigquery_analytics_hub_listing_subscription.data_subscription.linked_dataset_map
}

output "linked_resources" {
  description = "Linked resources created in the subscription"
  value       = google_bigquery_analytics_hub_listing_subscription.data_subscription.linked_resources
}

output "subscription_state" {
  description = "Current state of the subscription"
  value       = google_bigquery_analytics_hub_listing_subscription.data_subscription.state
}
