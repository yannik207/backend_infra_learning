resource "google_storage_bucket" "iceberg_lakehouse" {
  name     = "yannik-test-iceberg-lakehouse"
  location = "europe-west1"

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "data_folder" {
  name    = "data/"
  content = " "
  bucket  = google_storage_bucket.iceberg_lakehouse.name
}