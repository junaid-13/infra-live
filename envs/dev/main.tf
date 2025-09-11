locals {
  azs = ["us-east-1a","us-east-1b","us-east-1c"]
}

# 1) VPC (registry)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.8"

  name = "${var.name}-vpc"
  cidr = "10.20.0.0/16"

  azs             = local.azs
  private_subnets = [for i in range(3) : cidrsubnet("10.20.0.0/16", 4, i)]
  public_subnets  = [for i in range(3) : cidrsubnet("10.20.0.0/16", 8, i + 32)]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}

# 2) ECR (registry)
module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.4"

  for_each = toset(var.repos)

  repository_name                 = each.value
  repository_image_scan_on_push   = true
  repository_image_tag_mutability = "MUTABLE"

  tags = merge(var.tags, { "Service" = each.value })
}

# 3) EKS (local wrapper module)
module "eks" {
  source = "../../modules/eks"  # local path → no "version" here

  cluster_name = "${var.name}-eks"
  ver          = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  instance_types = ["t3.medium"]
  capacity_type  = "SPOT"
  desired_size   = 2
  min_size       = 1
  max_size       = 4

  tags = var.tags
}

# 4) Argo CD (helm) — installs after providers are ready (which wait for EKS)
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.9.3"
  create_namespace = true

  values = [yamlencode({
    configs = { params = { "server.insecure" = true } }
    server  = { service = { type = "ClusterIP" } }
  })]

  depends_on = [ module.eks ] # belt-and-suspenders
}

# 5) Seed app-of-apps Application (kubectl provider)
resource "kubectl_manifest" "root_app" {
  yaml_body  = templatefile("${path.module}/root-app.tmpl.yaml", {
    app_name  = "root-apps",
    namespace = "argocd",
    repo_url  = "https://github.com/junaid-13/platform-gitops",
    revision  = "main",
    path      = "argocd/root"
  })
  depends_on = [ helm_release.argocd ]
}