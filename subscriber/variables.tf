# Infrastructure Variables
variable "organization_id" {
  description = "GCP Organization ID where project will be created"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for project ID"
  type        = string
}

variable "billing_account_id" {
  description = "Billing account ID to associate with project"
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

# Publisher/Exchange Configuration (for subscription)
variable "exchange_project_id" {
  description = "Project ID of the Analytics Hub exchange project"
  type        = string
}

variable "data_exchange_id" {
  description = "Data exchange ID in the exchange project"
  type        = string
}

variable "listing_id" {
  description = "Listing ID in the data exchange"
  type        = string
}

