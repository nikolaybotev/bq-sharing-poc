# VPC Service Controls Service Perimeter for bq-publisher (merged with bq-exchange)
resource "google_access_context_manager_service_perimeter" "publisher_single_project_perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.policy.name}/servicePerimeters/bq_publisher_single_project_perimeter"
  title  = "bq-publisher-single-project-perimeter"

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

    ingress_policies {
      title = "Data Customer Subscribes to Listing and Creates Linked Dataset"

      ingress_from {
        identities = [
          var.subscriber_principal
        ]
        sources {
          access_level = "*"
        }
      }

      ingress_to {
        resources = [
          "projects/${google_project.bq_publisher.number}",
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

    egress_policies {
      title = "Analytics Hub Creates Linked Dataset in Data Customer Subscription Project"

      egress_from {
        identity_type = "ANY_IDENTITY"
      }

      egress_to {
        resources = [
          "projects/${var.subscriber_project_number}",
        ]

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
