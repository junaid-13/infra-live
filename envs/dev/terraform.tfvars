region = "us-east-1"
name   = "fintech-dev"

tags = {
  Owner           = "platform"
  CostCenter      = "fintech"
  Env             = "dev"
  app             = "fintech-platform"
  "finops.io/env" = "dev"
}

repos = ["accounts-api", "payments-api", "pricing-api"]