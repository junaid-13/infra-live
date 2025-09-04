output "repo_url"{
    value = {for k, m in module.ecr : k => m.repository_url}
}