terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55"
    }
  }
}

provider "aws" {}


resource "aws_kms_key" "this" {
  description = "${var.name} KMS key"
  deletion_window_in_days = 10
  enable_key_rotation = true
  tags = var.tags
}

resource "aws_kms_alias" "alias" {
  name = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

