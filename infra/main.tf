module "postgres" {
  source = "./postgres_api"

  # postgres variables
  postgres_password = var.postgres_password
  admin_mail        = var.admin_mail
  admin_password    = var.admin_password

  # api variables
  tag   = var.api_tag
  image = var.api_image

  # google project
  cloud_project = var.cloud_project
  cloud_region  = var.cloud_region
}

module "icebörg" {
  source = "./iceberg"

  # google project
  cloud_project = var.cloud_project
  cloud_region  = var.cloud_region
}