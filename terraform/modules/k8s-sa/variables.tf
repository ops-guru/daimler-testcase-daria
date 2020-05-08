# provider configuration variables declaration
variable "yc_token" {default = ""}
variable "yc_zone" {default = ""}
variable "yc_storage_access_key" {default = ""}
variable "yc_storage_secret_key" {default = ""}
variable "yc_service_account_key_file" {default = ""}
variable "yc_cloud_id" {}
variable "yc_folder_id" {}

# state variables
variable "state_endpoint" {}
variable "state_bucket" {}
variable "state_region" {}

# module variables
variable "name" {}
variable "labels" {
    type = map
    default = {}
}