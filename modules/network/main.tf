terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.55"
  }
}
}

provider "aws" {}




module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "~5.8"

    name = var.name
    cidr = var.cidr
    azs = var.azs

    private_subnets = [for i in range(length(var.azs)) : cidrsubnet(var.cidr,4,i)]
    public_subnets = [for i in range(length(var.azs)) : cidrsubnet(var.cidr,8,i + 32)]

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

    enable_dns_hostnames = true
    enable_dns_support = true

    tags = var.tags
}