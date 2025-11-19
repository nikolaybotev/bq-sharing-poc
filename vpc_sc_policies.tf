# VPC Service Controls Ingress Policy for bq-publisher
# Allows BigQuery queries from bq-subscriber and bq-exchange projects
resource "google_access_context_manager_service_perimeter_ingress_policy" "publisher_ingress" {
  perimeter = google_access_context_manager_service_perimeter.publisher_perimeter.name

  ingress_from {
    identity_type = "ANY_IDENTITY"

    sources {
      access_level = google_access_context_manager_access_level.allowed_ips.name
    }

    sources {
      resource = "projects/${google_project.bq_subscriber.number}"
    }

    sources {
      resource = "projects/${google_project.bq_exchange.number}"
    }
  }

  ingress_to {
    resources = ["*"]

    operations {
      service_name = "bigquery.googleapis.com"

      method_selectors {
        method = "google.cloud.bigquery.v2.JobService.Query"
      }

      method_selectors {
        method = "google.cloud.bigquery.v2.JobService.GetQueryResults"
      }

      method_selectors {
        method = "google.cloud.bigquery.v2.JobService.InsertJob"
      }
    }

    operations {
      service_name = "bigquerystorage.googleapis.com"
    }

    operations {
      service_name = "analyticshub.googleapis.com"
    }
  }
}

# VPC Service Controls Egress Policy for bq-publisher
# Allows access to bq-subscriber for data sharing
resource "google_access_context_manager_service_perimeter_egress_policy" "publisher_egress" {
  perimeter = google_access_context_manager_service_perimeter.publisher_perimeter.name

  egress_from {
    identity_type = "ANY_IDENTITY"
  }

  egress_to {
    resources = ["projects/${google_project.bq_subscriber.number}"]

    operations {
      service_name = "bigquery.googleapis.com"
    }

    operations {
      service_name = "analyticshub.googleapis.com"
    }
  }
}

# VPC Service Controls Ingress Policy for bq-exchange
# Allows BigQuery queries and subscription operations from bq-subscriber project
resource "google_access_context_manager_service_perimeter_ingress_policy" "exchange_ingress" {
  perimeter = google_access_context_manager_service_perimeter.exchange_perimeter.name

  ingress_from {
    identity_type = "ANY_IDENTITY"

    sources {
      access_level = google_access_context_manager_access_level.allowed_ips.name
    }

    sources {
      resource = "projects/${google_project.bq_subscriber.number}"
    }
  }

  ingress_to {
    resources = ["*"]

    operations {
      service_name = "bigquery.googleapis.com"

      method_selectors {
        method = "google.cloud.bigquery.v2.JobService.Query"
      }

      method_selectors {
        method = "google.cloud.bigquery.v2.JobService.GetQueryResults"
      }
    }

    operations {
      service_name = "analyticshub.googleapis.com"

      method_selectors {
        method = "google.cloud.bigquery.analyticshub.v1.AnalyticsHubService.SubscribeListing"
      }

      method_selectors {
        method = "google.cloud.bigquery.analyticshub.v1.AnalyticsHubService.GetSubscription"
      }

      method_selectors {
        method = "google.cloud.bigquery.analyticshub.v1.AnalyticsHubService.ListSubscriptions"
      }
    }
  }
}

# VPC Service Controls Egress Policy for bq-exchange
# Allows access to bq-subscriber and bq-publisher for data sharing
resource "google_access_context_manager_service_perimeter_egress_policy" "exchange_egress" {
  perimeter = google_access_context_manager_service_perimeter.exchange_perimeter.name

  egress_from {
    identity_type = "ANY_IDENTITY"
  }

  egress_to {
    resources = [
      "projects/${google_project.bq_subscriber.number}",
      "projects/${google_project.bq_publisher.number}"
    ]

    operations {
      service_name = "bigquery.googleapis.com"
    }

    operations {
      service_name = "bigquerystorage.googleapis.com"
    }

    operations {
      service_name = "analyticshub.googleapis.com"
    }
  }
}

