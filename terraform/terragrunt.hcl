terraform {
  extra_arguments "common" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var",
      "yc_service_account_key_file=${find_in_parent_folders("terraform_yandex.json")}",

      "-var",
      "yc_cloud_id=${local.common.yc_cloud_id}",
      "-var",
      "state_endpoint=${local.common.state_endpoint}",
      "-var",
      "state_region=${local.common.state_region}",

      "-var",
      "yc_folder_id=${local.secret.yc_folder_id}",
      "-var",
      "state_bucket=${local.secret.state_bucket}"

    ]
  }
}

locals {
  common = yamldecode(file("common_vars.yaml")).common
  secret = yamldecode(file("secret_vars.yaml"))
}


remote_state {
  backend = "s3" 
  config = {
    endpoint                    = "https://storage.yandexcloud.net"
    bucket                      = "${get_env("STATE_BUCKET","")}"
    region                      = "ru-central1"
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}