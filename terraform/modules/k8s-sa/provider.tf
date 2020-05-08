provider "yandex" {
  token                     = var.yc_token
  service_account_key_file  = var.yc_service_account_key_file
  cloud_id                  = var.yc_cloud_id
  folder_id                 = var.yc_folder_id
  zone                      = var.yc_zone
  storage_access_key        = var.yc_storage_access_key
  storage_secret_key        = var.yc_storage_secret_key
}