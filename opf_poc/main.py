from pyiceberg.catalog import load_catalog
import pyarrow.parquet as pq
import pyarrow.compute as pc
from os import getenv


postgres_connection = getenv("postgres")

warehouse_path = "yannik-test-iceberg-lakehouse"
catalog = load_catalog(
    "default",
    **{
        'type': 'sql',
        "uri": f"{postgres_connection}",
        "warehouse": f"gs://{warehouse_path}",
    },
)

df = pq.read_table("./warehouse/yellow_tripdata_2023-01.parquet")

ns = catalog.list_namespaces()
if ns != [("default",)]:
    catalog.create_namespace("default")

if catalog.table_exists("default.taxi_dataset") == False:
    table = catalog.create_table(
        "default.taxi_dataset",
        schema=df.schema,
    )
else:
    table = catalog.load_table("default.taxi_dataset")

table.overwrite(df)

# print(table.scan().to_arrow())
# print(table.inspect.snapshots())
print(table.inspect.partitions())
#df = df.append_column("tip_per_mile", pc.divide(df["tip_amount"], df["trip_distance"]))