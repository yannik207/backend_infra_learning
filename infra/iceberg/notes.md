# learnings and notes I can use in the future

## learning:
U suck in programming


### list all resources
```

ACCESS_TOKEN=$(gcloud auth print-access-token)

curl -X GET \
  -H "Authorization: $ACCESS_TOKEN" \
  -H "Accept: application/json" \
  "https://biglake.googleapis.com/v1/projects/YOUR_PROJECT/locations/YOUR_CATALOG_LOCATION/catalogs/YOUR_CATALOG_NAME/databases"
```


### query iceberg via bigquery
```
-- Stored Procedure Example
create or replace procedure cymbal_retail.iceberg_load_3_2 (
)
WITH CONNECTION `bq-huron.us.cymbal-retail-spark`
OPTIONS(engine="SPARK",
  jar_uris=["gs://cymbal-retail-config/iceberg-biglake-catalog-dataproc2.0-iceberg0.14-0.0.1.signed.jar",
            "gs://cymbal-retail-config/conscrypt-openjdk-2.5.2-linux-x86_64.jar"],
  properties=[("spark.jars.packages", "org.apache.iceberg:iceberg-spark-runtime-3.2_2.12:0.14.1"),
              ("spark.sql.catalog.cymbal_retail_catalog", "org.apache.iceberg.spark.SparkCatalog"),
              ("spark.sql.catalog.cymbal_retail_catalog.catalog-impl", "org.apache.iceberg.gcp.biglake.BigLakeCatalog"),
              ("spark.sql.catalog.cymbal_retail_catalog.gcp_project", "bq-huron"),
              ("spark.sql.catalog.cymbal_retail_catalog.gcp_location", "us"),
              ("spark.sql.catalog.cymbal_retail_catalog.blms_catalog", "cymbal_retail_catalog"),
              ("spark.sql.catalog.cymbal_retail_catalog.warehouse", "gs://cymbal-retail-lake/hive-warehouse")
  ]
)

LANGUAGE PYTHON AS R"""
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("BigLake Iceberg Example") \
    .enableHiveSupport() \
    .getOrCreate()

spark.sql("CREATE NAMESPACE IF NOT EXISTS cymbal_retail_catalog.retail_db;")

spark.sql("CREATE TABLE IF NOT EXISTS cymbal_retail_catalog.retail_db.products (id bigint, product_name string) USING iceberg TBLPROPERTIES (bq_table='cymbal_retail.products', bq_connection='us.cymbal_retail.data');")

spark.sql("INSERT INTO cymbal_retail_catalog.retail_db.products VALUES (1, 'Donuts'), (2, 'Waffles'), (3, 'Breakfast Sandwich')").show()
"""
;

```