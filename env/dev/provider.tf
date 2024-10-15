terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  #credentials = file(var.sa_credentials_file_path)
  project = var.gcp_project
  region = var.gcp_region
}