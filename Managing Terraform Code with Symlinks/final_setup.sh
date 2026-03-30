#!/bin/bash
BASE="/home/bob/terraform"

echo "--- 1. Creating Directory Structure ---"
mkdir -p $BASE/modules/sns
mkdir -p $BASE/modules/ssm
mkdir -p $BASE/modules/stepfunctions

echo "--- 2. Creating Root Files ---"

# Root variables.tf
cat << 'EOF' > $BASE/variables.tf
variable "KKE_SNS_TOPIC_NAME" {}
variable "KKE_SSM_PARAM_NAME" {}
variable "KKE_STEP_FUNCTION_NAME" {}
EOF

# Root terraform.tfvars
cat << 'EOF' > $BASE/terraform.tfvars
KKE_SNS_TOPIC_NAME     = "nautilus-sns-topic"
KKE_SSM_PARAM_NAME     = "nautilus-param"
KKE_STEP_FUNCTION_NAME  = "nautilus-stepfunction"
EOF

# Root main.tf (Orchestration)
cat << 'EOF' > $BASE/main.tf
module "sns" {
  source             = "./modules/sns"
  KKE_SNS_TOPIC_NAME = var.KKE_SNS_TOPIC_NAME
}

module "ssm" {
  source             = "./modules/ssm"
  KKE_SSM_PARAM_NAME = var.KKE_SSM_PARAM_NAME
  sns_topic_arn      = module.sns.arn
  depends_on         = [module.sns]
}

module "stepfunctions" {
  source                 = "./modules/stepfunctions"
  KKE_STEP_FUNCTION_NAME = var.KKE_STEP_FUNCTION_NAME
  ssm_parameter_name     = module.ssm.name
  depends_on             = [module.ssm]
}
EOF

# Root outputs.tf
cat << 'EOF' > $BASE/outputs.tf
output "kke_sns_topic_name" { value = module.sns.name }
output "kke_ssm_parameter_name" { value = module.ssm.name }
output "kke_step_function_name" { value = module.stepfunctions.name }
EOF

echo "--- 3. Creating Module Files ---"

# SNS Module
cat << 'EOF' > $BASE/modules/sns/main.tf
resource "aws_sns_topic" "topic" {
  name = var.KKE_SNS_TOPIC_NAME
}
output "name" { value = aws_sns_topic.topic.name }
output "arn"  { value = aws_sns_topic.topic.arn }
EOF

# SSM Module
cat << 'EOF' > $BASE/modules/ssm/main.tf
variable "sns_topic_arn" {}
resource "aws_ssm_parameter" "param" {
  name  = var.KKE_SSM_PARAM_NAME
  type  = "String"
  value = var.sns_topic_arn
}
output "name" { value = aws_ssm_parameter.param.name }
EOF

# Step Functions Module
cat << 'EOF' > $BASE/modules/stepfunctions/main.tf
variable "ssm_parameter_name" {}

resource "aws_iam_role" "iam_for_sfn" {
  name = "${var.KKE_STEP_FUNCTION_NAME}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "states.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "sfn_policy" {
  name = "ssm_get_param_policy"
  role = aws_iam_role.iam_for_sfn.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "ssm:GetParameter"
      Effect = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_sfn_state_machine" "sfn" {
  name     = var.KKE_STEP_FUNCTION_NAME
  role_arn = aws_iam_role.iam_for_sfn.arn
  definition = jsonencode({
    StartAt = "PassState"
    States = {
      PassState = {
        Type = "Pass"
        Result = "Retrieving ${var.ssm_parameter_name}"
        End = true
      }
    }
  })
}
output "name" { value = aws_sfn_state_machine.sfn.name }
EOF

echo "--- 4. Creating Absolute Path Symlinks for variables.tf ---"
for MOD in sns ssm stepfunctions; do
  ln -sf $BASE/variables.tf $BASE/modules/$MOD/variables.tf
  echo "Linked variables.tf to modules/$MOD"
done

echo "--- Setup Finished Successfully! ---"



terraform init
terraform apply -auto-approve
