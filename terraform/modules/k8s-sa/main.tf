resource "yandex_iam_service_account" "k8s_sa" {
  name        = "sa-${var.yc_folder_id}-${var.name}"
  folder_id = var.yc_folder_id
  description = "Service account for K8s cluster ${var.name}"
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_sa" {
  folder_id = var.yc_folder_id
  role = "editor"
  members = ["serviceAccount:${yandex_iam_service_account.k8s_sa.id}"]
}

resource "yandex_iam_service_account" "k8s_node_sa" {
  name        = "node-sa-${var.yc_folder_id}-${var.name}"
  folder_id = var.yc_folder_id
  description = "Service account for K8s cluster ${var.name} nodes"
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_node_sa" {
  folder_id = var.yc_folder_id
  role = "editor"
  members = ["serviceAccount:${yandex_iam_service_account.k8s_node_sa.id}"]
}

output "k8s_sa" {
  value = yandex_iam_service_account.k8s_sa.id
}

output "k8s_node_sa" {
  value = yandex_iam_service_account.k8s_node_sa.id
}

