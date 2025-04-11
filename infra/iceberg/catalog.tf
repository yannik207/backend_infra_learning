resource "google_storage_bucket_object" "metadata_folder" {
  name    = "metadata/"
  content = " "
  bucket  = google_storage_bucket.iceberg_lakehouse.name
}

resource "google_biglake_catalog" "iceboerg-catalog" {
  name     = "yanniks_iceboerg_catalog"
  location = "EU"
}

resource "google_biglake_database" "icebörg-catalog-database" {
  name    = "yanniks_iceboerg_catalog_database"
  catalog = google_biglake_catalog.iceboerg-catalog.id
  type    = "HIVE"
  hive_options {
    location_uri = "${google_storage_bucket.iceberg_lakehouse.name}/${google_storage_bucket_object.metadata_folder.name}"
    parameters = {
      "owner" = "Why SL Know Plug"
    }
  }
}

output "catalog_uri" {
  value = google_biglake_database.icebörg-catalog-database.hive_options[0].location_uri
}

# ## from terraform registry
# resource "google_biglake_table" "icebörg-catalog-database-table" {
#   name     = "mbeezy"
#   database = google_biglake_database.icebörg-catalog-database.id
#   type     = "HIVE"
#   hive_options {
#     table_type = "MANAGED_TABLE"
#     storage_descriptor {
#       location_uri  = "gs://${google_storage_bucket.iceberg_lakehouse.name}/${google_storage_bucket_object.data_folder.name}"
#       input_format  = "org.apache.hadoop.mapred.SequenceFileInputFormat"
#       output_format = "org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat"
#     }
#     # Some Example Parameters.
#     parameters = {
#       "spark.sql.create.version"          = "3.1.3"
#       "spark.sql.sources.schema.numParts" = "1"
#       "transient_lastDdlTime"             = "1680894197"
#       "spark.sql.partitionProvider"       = "catalog"
#       "owner"                             = "Money boy aka mbeezy"
#       "spark.sql.sources.schema.part.0"   = "{\"type\":\"struct\",\"fields\":[{\"name\":\"id\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}},{\"name\":\"name\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"age\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}}]}"
#       "spark.sql.sources.provider"        = "iceberg"
#       "provider"                          = "iceberg"
#     }
#   }
# }