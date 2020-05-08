terraform {
    backend "s3" {}
}

data "terraform_remote_state" "k8s-sa" {
  backend = "s3"

  config = {
    endpoint                    = var.state_endpoint
    bucket                      = var.state_bucket
    region                      = var.state_region
    key                         = "resources/k8s-sa/terraform.tfstate"
    
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}