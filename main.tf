terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "portfolio" {
  metadata {
    name = "portfolio"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "environment" = "local"
    }
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "environment" = "local"
    }
  }
}

# Resource Quotas for the portfolio namespace
resource "kubernetes_resource_quota" "portfolio_quota" {
  metadata {
    name = "portfolio-quota"
    namespace = kubernetes_namespace.portfolio.metadata[0].name
  }
  spec {
    hard = {
      "requests.cpu" = "1"
      "requests.memory" = "1Gi"
      "limits.cpu" = "2"
      "limits.memory" = "2Gi"
      "pods" = "10"
    }
  }
}
