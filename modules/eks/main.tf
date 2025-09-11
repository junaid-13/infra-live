terraform {
  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.55" }
    kubernetes = { source = "hashicorp/kubernetes", version = "~> 2.32" }
    helm       = { source = "hashicorp/helm",       version = "~> 2.14" }
  }
}

# Providers for kubernetes/helm are configured by the caller (env stack).

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.24"

  cluster_name                   = var.cluster_name
  cluster_version                = var.ver            # keep your 'ver' var
  cluster_endpoint_public_access = true
  enable_irsa                    = true

  # ✅ Explicit inputs (no guessing via tags/data sources)
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    dev_spot = {
      ami_type       = "AL2_x86_64"
      instance_types = var.instance_types
      capacity_type  = var.capacity_type
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
      labels = {
        "finops.io/env" = "dev"
        "workload"      = "general"
      }
      tags = var.tags
    }
  }

  tags = var.tags
}
