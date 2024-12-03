terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  project = "${var.project-id}"
  region = "${var.region}"
  credentials = "../credentials/terraform-workshop-sa.json"
}