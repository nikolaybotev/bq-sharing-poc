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

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "BigQuery location (e.g., 'us', 'eu')"
  type        = string
  default     = "us-central1"
}

variable "dataset_id" {
  description = "BigQuery dataset ID in bq-publisher project"
  type        = string
  default     = "shared_dataset"
}

variable "exchange_id" {
  description = "BigQuery Sharing data exchange ID"
  type        = string
  default     = "data-exchange"
}

variable "exchange_display_name" {
  description = "Display name for the data exchange"
  type        = string
  default     = "Data Exchange"
}

variable "exchange_description" {
  description = "Description for the data exchange"
  type        = string
  default     = "BigQuery data sharing exchange"
}

variable "listing_id" {
  description = "BigQuery Sharing listing ID"
  type        = string
  default     = "data-listing"
}

variable "listing_display_name" {
  description = "Display name for the listing"
  type        = string
  default     = "Shared Dataset Listing"
}

variable "listing_description" {
  description = "Description for the listing"
  type        = string
  default     = "Shared BigQuery dataset"
}

variable "subscription_id" {
  description = "BigQuery Sharing subscription ID"
  type        = string
  default     = "data-subscription"
}

variable "primary_contact" {
  description = "Primary contact email for data exchange and listing"
  type        = string
}

variable "data_provider_name" {
  description = "Name of the data provider"
  type        = string
  default     = "Data Provider"
}
