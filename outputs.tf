output "bq_publisher_project_id" {
  description = "Project ID for bq-publisher"
  value       = google_project.bq_publisher.project_id
}

output "bq_exchange_project_id" {
  description = "Project ID for bq-exchange"
  value       = google_project.bq_exchange.project_id
}

output "bq_subscriber_project_id" {
  description = "Project ID for bq-subscriber"
  value       = google_project.bq_subscriber.project_id
}

output "bq_publisher_project_number" {
  description = "Project number for bq-publisher"
  value       = google_project.bq_publisher.number
}

output "bq_exchange_project_number" {
  description = "Project number for bq-exchange"
  value       = google_project.bq_exchange.number
}

output "bq_subscriber_project_number" {
  description = "Project number for bq-subscriber"
  value       = google_project.bq_subscriber.number
}

output "bigquery_dataset_id" {
  description = "BigQuery dataset ID in bq-publisher project"
  value       = google_bigquery_dataset.shared_dataset.dataset_id
}

output "bigquery_dataset_full_id" {
  description = "Full BigQuery dataset ID"
  value       = google_bigquery_dataset.shared_dataset.id
}

output "data_exchange_id" {
  description = "BigQuery Sharing data exchange ID"
  value       = google_bigquery_analytics_hub_data_exchange.data_exchange.data_exchange_id
}

output "data_exchange_name" {
  description = "Full resource name of the data exchange"
  value       = google_bigquery_analytics_hub_data_exchange.data_exchange.name
}

output "listing_id" {
  description = "BigQuery Sharing listing ID"
  value       = google_bigquery_analytics_hub_listing.data_listing.listing_id
}

output "listing_name" {
  description = "Full resource name of the listing"
  value       = google_bigquery_analytics_hub_listing.data_listing.name
}

output "subscription_id" {
  description = "BigQuery Sharing subscription ID"
  value       = google_bigquery_analytics_hub_subscription.data_subscription.subscription_id
}

output "subscription_name" {
  description = "Full resource name of the subscription"
  value       = google_bigquery_analytics_hub_subscription.data_subscription.name
}

output "access_level_name" {
  description = "VPC Service Controls access level name"
  value       = google_access_context_manager_access_level.allowed_ips.name
}

output "service_perimeter_publisher_name" {
  description = "Publisher service perimeter name"
  value       = google_access_context_manager_service_perimeter.publisher_perimeter.name
}

output "service_perimeter_exchange_name" {
  description = "Exchange service perimeter name"
  value       = google_access_context_manager_service_perimeter.exchange_perimeter.name
}

output "access_policy_name" {
  description = "Access policy name"
  value       = google_access_context_manager_access_policy.policy.name
}

