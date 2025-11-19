# Organization Policy: Allow specific organization customer IDs for IAM policy members
# This is required when granting IAM roles to users from external organizations
# Policy enforcement: Merge with parent (default behavior - project policy merges with organization policy)
# See https://cloud.google.com/resource-manager/docs/organization-policy/restricting-domains#retrieving_customer_id
resource "google_project_organization_policy" "allowed_policy_member_domains" {
  project    = google_project.bq_exchange.project_id
  constraint = "iam.allowedPolicyMemberDomains"

  list_policy {
    allow {
      # Format: is:C00m10csx, is:C03di8z8f
      # These values will be merged with any values from the parent organization policy
      values = [for id in var.allowed_organization_customer_ids : "is:${id}"]
    }
  }

  depends_on = [
    google_project.bq_exchange
  ]
}
