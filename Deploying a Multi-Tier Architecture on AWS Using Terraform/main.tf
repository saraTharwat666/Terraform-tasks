# 1. DynamoDB Table (Minimal Config)
resource "aws_dynamodb_table" "app_table" {
  name         = var.KKE_DYNAMODB_TABLE_NAME
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }

  tags = {
    Environment = var.KKE_ENVIRONMENT
  }
}

# 2. SNS Topic
resource "aws_sns_topic" "app_topic" {
  name = var.KKE_SNS_TOPIC_NAME

  tags = {
    Environment = var.KKE_ENVIRONMENT
  }
}

# 3. SSM Parameter (Secure String)
resource "aws_ssm_parameter" "app_config" {
  name  = var.KKE_SSM_PARAM_NAME
  type  = "SecureString"
  value = "nautilus-secure-config-value" # قيمة تجريبية

  tags = {
    Environment = var.KKE_ENVIRONMENT
  }
}
