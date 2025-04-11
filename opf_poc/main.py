from pyiceberg.catalog import load_catalog
import pyarrow.parquet as pq
import pyarrow.compute as pc

warehouse_path = "./warehouse"
catalog = load_catalog(
    "default",
    **{
        'type': 'sql',
        "uri": f"sqlite:///{warehouse_path}/pyiceberg_catalog.db",
        "warehouse": f"file://{warehouse_path}",
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
print(table.scan().to_arrow())

#df = df.append_column("tip_per_mile", pc.divide(df["tip_amount"], df["trip_distance"]))