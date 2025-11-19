# Infrastructure Configuration

variable "organization_id" {
  description = "GCP Organization ID where projects will be created"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for all project IDs"
  type        = string
}

variable "allowed_ip_cidr_blocks" {
  description = "List of IP CIDR blocks allowed by VPC Service Controls access level"
  type        = list(string)
  default     = []
}

variable "billing_account_id" {
  description = "Billing account ID to associate with projects"
  type        = string
}

variable "quota_project_id" {
  description = "Project ID to use for quota/billing when using Application Default Credentials. Must be an existing project with billing enabled."
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

# Publisher Configuration

variable "publisher_primary_contact" {
  description = "Primary contact email for data exchange and listing"
  type        = string
}

# Subscriber Configuration

variable "subscriber_customer_id" {
  description = "Subscriber customer ID to be allowed for IAM policy members (e.g., 'C00n20csy')"
  type        = string
}

variable "subscriber_project_number" {
  description = "Project number of the subscriber project (e.g., '618045648662')"
  type        = string
}

variable "subscriber_principal" {
  description = "IAM principal of the subscriber (e.g., 'user:johndoe@nsubscriber.com')"
  type        = string
}
