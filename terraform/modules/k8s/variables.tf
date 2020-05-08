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
variable "subnet_id" {}
variable "cluster_version" {default = ""}
variable "public_ip" {default = "true"}
variable "auto_upgrade" {default = "false"}
variable "maintenance_window" {
    type = map
    default = {
        start_time    = "15:00"
        duration      = "3h"
        day           = "sunday"
    }
}

variable "release_channel" {default = "STABLE"}
variable "cluster_type" {default = "zonal"}
variable "zone" {default = "ru-central1-a"}

#   variables for np
variable "platform_id" {default = "standard-v2"}
variable "nat" {default = "false"}
variable "cores" {default = 2}
variable "memory" {default = 4}
variable "boot_disk_size" {default = 64}
variable "boot_disk_type" {default = "network-ssd"}
variable "preemptible" {default = false}
variable "fixed_scale" {
    type = map
    default = {}
}
variable "auto_scale" {
    type = map
    default = {}
}


variable "auto_repair" {default = "false"}

variable "cluster_ipv4_range" {}
variable "service_ipv4_range" {}
variable "network_id" {}