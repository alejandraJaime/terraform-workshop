resource "random_id" "default" {
  byte_length = 4
}

resource "google_storage_bucket" "function-bucket" {
  # El nombre del bucket debe ser unico a nivel global en GCP
  name                        = "${var.user-prefix}-${random_id.default.hex}-source" 
  location                    = "${var.gcp_region}"
  project                     = "${var.gcp_project}"
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "./src"
}

resource "google_storage_bucket_object" "cf-source" {
  name   = "${var.user-prefix}-function-src.zip"
  bucket = google_storage_bucket.function-bucket.name
  
  # Add path to the zipped function source code
  source = data.archive_file.default.output_path 
}

resource "google_cloudfunctions2_function" "default" {
  name        = "${var.user-prefix}-airport-information-parser"
  location    = "${var.gcp_project}"
  description = "a new function"

  build_config {
    runtime     = "nodejs18"
    entry_point = "main" # Set the entry point
    source {
      storage_source {
        bucket = google_storage_bucket.function-bucket.name
        object = google_storage_bucket_object.cf-source.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.default.location
  service  = google_cloudfunctions2_function.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "function_uri" {
  value = google_cloudfunctions2_function.default.service_config[0].uri
}