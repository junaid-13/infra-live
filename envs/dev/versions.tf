terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws        = { 
        source = "hashicorp/aws", 
        version = "~> 5.55"
         }
    helm       = { 
        source = "hashicorp/helm",
        version = "~> 2.14" 
        }
    kubernetes = { 
        source = "hashicorp/kubernetes",
        version = "~> 2.32"
    }
    kubectl    = { 
        source = "gavinbunney/kubectl",
        version = "~> 1.14"
    }
  }
}
