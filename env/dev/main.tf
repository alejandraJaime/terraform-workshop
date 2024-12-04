resource "random_id" "default" {
  byte_length = 4
}

resource "google_storage_bucket" "default" {
  # El nombre del bucket debe ser unico a nivel global en GCP
  name                        = "${var.user-prefix}-${random_id.default.hex}-source" 
  location                    = "${var.gcp_region}"
  project                     = "${var.gcp_project}"
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "../../src"
}

resource "google_storage_bucket_object" "object" {
  # Se pasa en source el path del zip creado en el modulo archive_file
  name   = "${var.user-prefix}-${data.archive_file.default.output_md5}-function-src.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path 
}

resource "google_cloudfunctions_function" "default" {
  name        = "${var.user-prefix}-airport-information-parser"
  description = "first test function"
  runtime = "nodejs20"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.default.name
  source_archive_object = google_storage_bucket_object.object.name
  trigger_http          = true
  entry_point           = "main"
}

resource "google_cloud_scheduler_job" "job" {
  name             = "test-job"
  description      = "test http job"
  schedule         = "*/8 * * * *"
  time_zone        = "America/New_York"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions_function.default.https_trigger_url
    body        = base64encode("{\"country\":\"United States\"}")
    headers = {
      "Content-Type" = "application/json"
    }
  }
}

output "function_uri" {
  value = google_cloudfunctions_function.default.https_trigger_url #default.service_config[0].uri
}

output "function_uri" {
  value = google_cloudfunctions_function.default.https_trigger_url
}