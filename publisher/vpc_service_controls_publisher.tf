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

    # Required when the shared dataset and exchange are in different perimeters
    # so Analytics Hub can create/manage a listing that references the dataset.
    # See https://docs.cloud.google.com/bigquery/docs/analytics-hub-vpc-sc-rules#create_a_listing
    # (Figure 2: Project S egress to Project E). Caller access is covered by access_levels above.
    egress_policies {
      title = "Publisher Reaches Exchange Project For Listing Creation"

      egress_from {
        identity_type = "ANY_IDENTITY"
      }

      egress_to {
        resources = [
          "projects/${google_project.bq_exchange.number}",
        ]

        operations {
          service_name = "analyticshub.googleapis.com"
          method_selectors {
            method = "*"
          }
        }

        operations {
          service_name = "bigquery.googleapis.com"
          method_selectors {
            method = "*"
          }
        }
      }
    }
  }
}
