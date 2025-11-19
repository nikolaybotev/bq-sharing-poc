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
