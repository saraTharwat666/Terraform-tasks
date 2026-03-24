terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1" # عدّلي حسب المنطقة المطلوبة
}

# ---------------------------
# Locals: sanitize inputs, prefix, common tags
# ---------------------------
locals {
  sanitized_project = lower(regexreplace(var.KKE_PROJECT, "[^a-z0-9]", "-"))
  sanitized_team    = lower(regexreplace(var.KKE_TEAM, "[^a-z0-9]", "-"))

  resource_prefix = "${local.sanitized_project}-${local.sanitized_team}"

  common_tags = {
    Project   = local.sanitized_project
    Team      = local.sanitized_team
    ManagedBy = "Terraform"
    Env       = lower(var.KKE_ENVIRONMENT)
  }
}

# ---------------------------
# IAM User
# ---------------------------
resource "aws_iam_user" "user" {
  name = "${local.resource_prefix}-user"
  tags = local.common_tags
}

# ---------------------------
# IAM Role
# ---------------------------
resource "aws_iam_role" "role" {
  name = "${local.resource_prefix}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(local.common_tags, { RoleType = "EC2" })
}
