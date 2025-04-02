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

## from terraform registry
# needs to get populated
# resource "google_biglake_table" "table" {
#     name = "my_table"
#     database = google_biglake_database.database.id
#     type = "HIVE"
#     hive_options {
#       table_type = "MANAGED_TABLE"
#       storage_descriptor {
#         location_uri = "gs://${google_storage_bucket.bucket.name}/${google_storage_bucket_object.data_folder.name}"
#         input_format  = "org.apache.hadoop.mapred.SequenceFileInputFormat"
#         output_format = "org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat"
#       }
#       # Some Example Parameters.
#       parameters = {
#         "spark.sql.create.version" = "3.1.3"
#         "spark.sql.sources.schema.numParts" = "1"
#         "transient_lastDdlTime" = "1680894197"
#         "spark.sql.partitionProvider" = "catalog"
#         "owner" = "John Doe"
#         "spark.sql.sources.schema.part.0"= "{\"type\":\"struct\",\"fields\":[{\"name\":\"id\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}},{\"name\":\"name\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"age\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}}]}"
#         "spark.sql.sources.provider" = "iceberg"
#         "provider" = "iceberg"
#       }
#   }
# }