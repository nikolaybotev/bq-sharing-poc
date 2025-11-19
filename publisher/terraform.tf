terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

# Provider configuration
provider "google" {
  region = var.region

  # Set quota project for Application Default Credentials
  # This is required when using user credentials (gcloud auth application-default login)
  user_project_override = true
  billing_project       = var.quota_project_id
}

# Get organization details
data "google_organization" "org" {
  organization = var.organization_id
}
