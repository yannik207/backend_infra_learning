# learnings and notes I can use in the future

## learning:
U suck in programming

```
# list all resources

ACCESS_TOKEN=$(gcloud auth print-access-token)

curl -X GET \
  -H "Authorization: $ACCESS_TOKEN" \
  -H "Accept: application/json" \
  "https://biglake.googleapis.com/v1/projects/YOUR_PROJECT/locations/YOUR_CATALOG_LOCATION/catalogs/YOUR_CATALOG_NAME/databases"
```