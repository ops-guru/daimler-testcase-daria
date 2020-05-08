terraform {
  source = "../../modules/k8s-sa"
}

include {
    path = "${find_in_parent_folders()}"
}

inputs = {
  name                    = "dev"
}


