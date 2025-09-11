output "cluster_name"   { 
    value = module.eks.cluster_name
}
output "ecr_repo_urls"  { 
    value = { for k, m in module.ecr : k => m.repository_url } 
    }
output "vpc_id"         { 
    value = module.vpc.vpc_id
}
output "private_subnets"{ 
    value = module.vpc.private_subnets
}