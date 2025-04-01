# postgres
variable "admin_mail" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "postgres_password" {
  type = string
}

#api
variable "api_tag" {
  type = string
}

variable "api_image" {
  type = string
}

variable "cloud_project" {
  type = string
}

variable "cloud_region" {
  type = string
}