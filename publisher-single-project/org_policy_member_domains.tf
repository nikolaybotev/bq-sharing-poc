# Organization Policy: Allow specific subscriber customer ID for IAM policy members
# This is required when granting IAM roles to users from external organizations
# Policy enforcement: Merge with parent (default behavior - project policy merges with organization policy)
# See https://cloud.google.com/resource-manager/docs/organization-policy/restricting-domains#retrieving_customer_id
resource "google_org_policy_policy" "allowed_policy_member_domains" {
  name   = "projects/${google_project.bq_publisher.number}/policies/iam.allowedPolicyMemberDomains"
  parent = "projects/${google_project.bq_publisher.number}"

  spec {
    inherit_from_parent = true
    rules {
      values {
        # Format: is:C00n20csy
        # This value will be merged with any values from the parent organization policy
        allowed_values = ["${var.subscriber_customer_id}"]
      }
    }
  }

  depends_on = [
    google_project.bq_publisher
  ]
}
