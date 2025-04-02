resource "google_storage_bucket_object" "metadata_folder" {
  name    = "metadata/"
  content = " "
  bucket  = google_storage_bucket.iceberg_lakehouse.name
}

resource "google_biglake_catalog" "iceboerg-catalog" {
  name     = "yanniks_iceboerg_catalog"
  location = "EU"
}

resource "google_biglake_database" "name" {
  name    = "yanniks_iceboerg_catalog_database"
  catalog = google_biglake_catalog.iceboerg-catalog.id
  type    = "HIVE"
  hive_options {
    location_uri = "${google_storage_bucket_object.metadata_folder.bucket}/${google_storage_bucket_object.metadata_folder.name}"
    parameters = {
      "owner" = "yannik"
    }
  }
}
