terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region = var.gcp_region
  credentials = file("../../credentials/terraform-workshop-sa.json")
}