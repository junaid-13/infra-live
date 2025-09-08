terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.55"
    }
  }
}

provider "aws" {}

locals {
  common = {
  time_unit         = "MONTHLY"
  budget_type       = "COST"
  time_period_start = "2025-09-02_00:00"
}
}
# DEV

resource "aws_budgets_budget" "dev" {
  name              = "fintech-dev-monthly"
  budget_type       = local.common.budget_type
  limit_amount      = local.amounts.dev
  limit_unit        = "USD"
  time_unit         = local.common.time_unit
  time_period_start = local.common.time_period_start

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.emails
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.emails
  }
}

# Stage
resource "aws_budgets_budget" "stage" {
  name              = "fintech-stage-monthly"
  budget_type       = local.common.budget_type
  limit_amount      = local.amounts.stage
  limit_unit        = "USD"
  time_unit         = local.common.time_unit
  time_period_start = local.common.time_period_start

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.emails
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.emails
  }
}

# Prod

resource "aws_budgets_budget" "prod" {
  name              = "fintech-prod-monthly"
  budget_type       = local.common.budget_type
  limit_amount      = local.amounts.prod
  limit_unit        = "USD"
  time_unit         = local.common.time_unit
  time_period_start = local.common.time_period_start

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = var.emails
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = var.emails
  }
}