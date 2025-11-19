# Access Policy for VPC Service Controls
resource "google_access_context_manager_access_policy" "policy" {
  parent = "organizations/${var.organization_id}"
  title  = "BQ Sharing Access Policy"
}

# VPC Service Controls Access Level
resource "google_access_context_manager_access_level" "allowed_ips" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.policy.name}/accessLevels/allowed_ips"
  title  = "allowed-ips"

  dynamic "basic" {
    for_each = length(var.allowed_ip_cidr_blocks) > 0 ? [1] : []
    content {
      conditions {
        ip_subnetworks = var.allowed_ip_cidr_blocks
      }
    }
  }

  # If no IP blocks provided, create a permissive access level
  dynamic "basic" {
    for_each = length(var.allowed_ip_cidr_blocks) == 0 ? [1] : []
    content {
      conditions {
        # Allow all IPs if no CIDR blocks specified
        ip_subnetworks = ["*"]
      }
    }
  }
}

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

  lifecycle {
    ignore_changes = [status[0].resources]
  }
}

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
      title = "External Party Subscribes to Listing and Creates Linked Dataset"

      ingress_from {
        identities = [
          "user:home@nikolaybotev.org"
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
      title = "Create Linked Dataset in Subscriber Project"

      egress_from {
        identity_type = "ANY_IDENTITY"
      }

      egress_to {
        resources = [
          "projects/${google_project.bq_subscriber.number}",
          "projects/618045648662", # external organization
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

  lifecycle {
    ignore_changes = [status[0].resources]
  }
}

# VPC Service Controls Service Perimeter for bq-subscriber (referencing access level)
resource "google_access_context_manager_service_perimeter" "subscriber_perimeter" {
  parent = "accessPolicies/${google_access_context_manager_access_policy.policy.name}"
  name   = "accessPolicies/${google_access_context_manager_access_policy.policy.name}/servicePerimeters/bq_subscriber_perimeter"
  title  = "bq-subscriber-perimeter"

  status {
    resources = [
      "projects/${google_project.bq_subscriber.number}"
    ]

    access_levels = [
      google_access_context_manager_access_level.allowed_ips.name
    ]
  }

  lifecycle {
    ignore_changes = [status[0].resources]
  }
}
