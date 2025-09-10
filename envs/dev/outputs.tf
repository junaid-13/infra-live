output "cluster_name" { value = module.eks.cluster_name }
output "ecr_repo_urls" { value = module.ecr.repo_url }
output "vpc_id" { value = module.network.vpc_id }
output "private_subnets" { value = module.network.private_subnets }
