resource "yandex_kubernetes_cluster" "my_cluster" {
  name                      = var.name
  folder_id                 = var.yc_folder_id
  labels                    = var.labels
  network_id                = var.network_id
  service_account_id        = data.terraform_remote_state.k8s-sa.outputs.k8s_sa
  node_service_account_id   = data.terraform_remote_state.k8s-sa.outputs.k8s_node_sa
  cluster_ipv4_range        = var.cluster_ipv4_range
  service_ipv4_range        = var.service_ipv4_range 
  
  release_channel           = var.release_channel
  master {
    version                   = var.cluster_version
    public_ip                 = var.public_ip 

    zonal {
      subnet_id = var.subnet_id
      zone      = var.zone
    }
    

    maintenance_policy {
      auto_upgrade        = var.auto_upgrade
      maintenance_window {
        start_time = var.maintenance_window.start_time
        duration   = var.maintenance_window.duration
        day        = var.maintenance_window.day
      } 
    }
  }
}


resource "yandex_kubernetes_node_group" "default" {
  cluster_id  = yandex_kubernetes_cluster.my_cluster.id
  name        = "${var.name}-default-np"
  labels      = var.labels
  version     = var.cluster_version
  instance_template {
    platform_id   = var.platform_id
    nat           = var.nat
    resources {
      cores   = var.cores
      memory  = var.memory
    }
    boot_disk {
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
    scheduling_policy {
      preemptible = var.preemptible
    }
  } 
  scale_policy {
    dynamic "fixed_scale" {
      for_each  = length(var.fixed_scale) > 0 ? [1] : []
      content {
        size = var.fixed_scale.size
      }
    }

    dynamic "auto_scale" {
      for_each  = length(var.auto_scale) > 0 ? [1] : []
      content {
        min     = var.auto_scale.min 
        max     = var.auto_scale.max
        initial = var.auto_scale.initial
      }
    }
  }
  
  allocation_policy {
    location {
      zone      = var.zone
      subnet_id = var.subnet_id
    }
  }

  maintenance_policy {
    auto_upgrade  = var.auto_upgrade
    auto_repair   = var.auto_repair
    maintenance_window {
      start_time = var.maintenance_window.start_time
      duration   = var.maintenance_window.duration
      day        = var.maintenance_window.day
    } 
  }
}




output "cluster_external_v4_endpoint" {
  value = yandex_kubernetes_cluster.my_cluster.master.0.external_v4_endpoint
}

output "internal_v4_endpoint" {
  value = yandex_kubernetes_cluster.my_cluster.master.0.internal_v4_endpoint
}

