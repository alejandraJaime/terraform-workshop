terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.12.0"
    }
  }
}

provider "google" {
  project = "mm-spla-tse-internal-hub"
  region = "us-east1"
  credentials = "../../credentials/terraform-workshop-sa.json"
}

variable "gcp_project" {
  type = string
  default = "mm-spla-tse-internal-hub"
}

# Region en que vamos a desplegar el bucket de GCS
variable "gcp_region" {
  type = string
  default = "us-east1"
}

# Agrega un prefijo unico para identificar tu infra 
variable "user-prefix" {
  type = string
  default = "ale-jaime"
}

resource "google_storage_bucket" "src-code" {
  # El nombre del bucket debe ser unico a nivel global en GCP
  name                        = "${var.user-prefix}-airports-parser-source-test" 
  location                    = "${var.gcp_region}"
  project                     = "${var.gcp_project}"
  uniform_bucket_level_access = true
}

data "archive_file" "source-zip" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "../../src"
}

resource "google_storage_bucket_object" "src-object" {
  # Se pasa en source el path del zip creado en el modulo archive_file
  name   = "${var.user-prefix}-${data.archive_file.source-zip.output_md5}-function-src.zip"
  bucket = google_storage_bucket.src-code.name
  source = data.archive_file.source-zip.output_path 
}

resource "google_cloudfunctions_function" "cf-parser" {
  name        = "${var.user-prefix}-airport-information-parser-test"
  runtime = "nodejs20"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.src-code.name
  source_archive_object = google_storage_bucket_object.src-object.name
  trigger_http          = true
  entry_point           = "main"
}