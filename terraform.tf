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
}

# Get organization details
data "google_organization" "org" {
  organization = var.organization_id
}
