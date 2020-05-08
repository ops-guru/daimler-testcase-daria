terraform {
  source = "../../modules/k8s"
}

include {
    path = "${find_in_parent_folders()}"
}

inputs = {
  name                    = "daimler-dev"
  cluster_type            = "zonal"
  cluster_version         = "1.15"
  public_ip               = "true"
  auto_upgrade            = "false"
  maintenance_window      = {
    start_time    = "15:00"
    duration      = "3h"
    day           = "sunday"
  }
  zone = "ru-central1-a"
  subnet_id = "e9bnmr2t84m01otqno9d"
  platform_id = "standard-v2"
  nat = "true"
  cores = 4
  memory = 8
  boot_disk_size = 200
  boot_disk_type = "network-ssd"
  preemptible = false
  auto_scale = {
    min     = 1
    max     = 3   
    initial = 1
  }
  cluster_ipv4_range = "10.113.0.0/16"
  service_ipv4_range = "10.97.0.0/16"
  network_id = "enpv1mk301f5hmrmmth5"
}


