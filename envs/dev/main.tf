locals {
  azs         = ["us-east-1a", "us-east-1b", "us-east-1c"]
  repos       = ["accounts-api", "payments-api", "pricing-api"]
  finops_tags = var.tags
}

module "network" {
  source = "../../modules/network"
  name   = "${var.name}-vpc"
  cidr   = "10.20.0.0/16"
  azs    = local.azs
  tags   = merge(local.finops_tags, { "Name" = "${var.name}-vpc" })
}

module "kms" {
  source = "../../modules/kms"
  name   = "${var.name}-kms"
  tags   = local.finops_tags
}

module "eks" {
  source         = "../../modules/eks"
  cluster_name   = "${var.name}-eks"
  ver            = "1.29"
  subnet_ids     = module.network.private_subnets
  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"
  desired_size   = 2
  min_size       = 1
  max_size       = 4
  tags           = local.finops_tags
}

module "ecr" {
  source       = "../../modules/ecr"
  repositories = local.repos
  tags         = local.finops_tags
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.9.3"

  create_namespace = true
  values = [yamlencode({
    configs = {
      params = {
        "server.insecure" = "true"
      }
    }
    server = {
      service = {
        type = "ClusterIP"
      }
    }
  })]
}


resource "kubernetes_manifest" "root_app" {
  manifest = yamldecode(templatefile("${path.module}/root-app.tmpl.yaml", {
    repo_url  = "https://github.com/junaid-13/platform-gitops"
    revision  = "main"
    path      = "argocd/root"
    app_name  = "root-apps"
    namespace = "argocd"
  }))
  depends_on = [helm_release.argocd]
}