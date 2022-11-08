
terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.15"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.7.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.15.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "3.10.0"
    }
  }
}


provider "vault" {
  # Configuration options
  address = ""
}


provider "kind" {
  # Configuration options
}

provider "helm" {
  kubernetes {
    config_path = "./admin.conf"
  }
}

provider "kubernetes" {
  config_path    = "./admin.conf"
  config_context = "kind-k8s-simple"
}
