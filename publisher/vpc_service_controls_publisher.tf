# VPC Service Controls Service Perimeter for bq-publisher
resource "google_access_context_manager_service_perimeter" "publisher_perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.policy.name}/servicePerimeters/bq_publisher_perimeter"
  title  = "bq-publisher-perimeter"

  status {
    resources = [
      "projects/${google_project.bq_publisher.number}"
    ]

    restricted_services = [
      "bigquery.googleapis.com",
      "analyticshub.googleapis.com"
    ]

    access_levels = [
      google_access_context_manager_access_level.allowed_ips.name
    ]
  }
}
