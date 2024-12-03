resource "google_storage_bucket" "src-code" {
  name                        = "${var.prefix}-airport-parser"
  location                    = "${var.region}"
  project                     = "${var.project-id}"
  uniform_bucket_level_access = true
}

data "archive_file" "source-zip" {
  type        = "zip"
  output_path = "/tmp/function-source.zip"
  source_dir  = "../src"
}

resource "google_storage_bucket_object" "source-zip" {
  name   = "airport-parser-source"
  source = data.archive_file.source-zip.output_path
  bucket = google_storage_bucket.src-code.name
}

resource "google_cloudfunctions_function" "function" {
  name        = "${var.prefix}-airport-parser-wk"
  runtime     = "nodejs20"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.src-code.name
  source_archive_object = google_storage_bucket_object.source-zip.name
  trigger_http          = true
  entry_point           = "main"
}