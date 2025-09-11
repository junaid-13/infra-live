terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.55" }
  }
}
provider "aws" {}

module "ecr" {
    source = "terraform-aws-modules/ecr/aws"
    version = "~>2.4"
    for_each = toset(var.repositories)
    repository_name = each.value
    repository_image_tag_mutability = "MUTABLE"
    repository_image_scan_on_push = true

    tags = merge(var.tags, {"Service" = each.value})
}
