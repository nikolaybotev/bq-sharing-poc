# VPC Service Controls Service Perimeter for bq-exchange
resource "google_access_context_manager_service_perimeter" "exchange_perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.policy.name}/servicePerimeters/bq_exchange_perimeter"
  title  = "bq-exchange-perimeter"

  status {
    resources = [
      "projects/${google_project.bq_exchange.number}"
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

    # Required when the shared dataset and exchange are in different perimeters
    # so Analytics Hub can create/manage a listing that references the dataset.
    # See https://docs.cloud.google.com/bigquery/docs/analytics-hub-vpc-sc-rules#create_a_listing
    # (Figure 2: Project E egress to Project S).
    egress_policies {
      title = "Exchange Accesses Shared Dataset In Publisher Project For Listing Creation"

      egress_from {
        identity_type = "ANY_IDENTITY"
      }

      egress_to {
        resources = [
          "projects/${google_project.bq_publisher.number}",
        ]

        # Validated: bigquery alone is sufficient for listing create; analyticshub
        # was not required on this egress path.
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
