#!/bin/bash
BASE="/home/bob/terraform"

echo "--- 1. Creating Directory Structure ---"
mkdir -p $BASE/modules/dynamodb
mkdir -p $BASE/modules/secretsmanager
mkdir -p $BASE/modules/elasticsearch
mkdir -p $BASE/env/dev
mkdir -p $BASE/env/prod

echo "--- 2. Creating Module Files (Fixed Format) ---"

# DynamoDB Module - Fixed formatting
cat << 'EOF' > $BASE/modules/dynamodb/main.tf
variable "table_name" {}
resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute {
    name = "id"
    type = "S"
  }
}
output "name" { value = aws_dynamodb_table.table.name }
EOF

# Secrets Manager Module - Fixed formatting
cat << 'EOF' > $BASE/modules/secretsmanager/main.tf
variable "secret_name" {}
variable "secret_value" {}
resource "aws_secretsmanager_secret" "secret" {
  name = var.secret_name
}
resource "aws_secretsmanager_secret_version" "val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_value
}
output "arn" { value = aws_secretsmanager_secret.secret.arn }
EOF

# Elasticsearch Module - Fixed formatting
cat << 'EOF' > $BASE/modules/elasticsearch/main.tf
variable "domain_name" {}
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain_name
  elasticsearch_version = "7.10"
  cluster_config {
    instance_type = "t3.small.elasticsearch"
  }
}
output "endpoint" { value = aws_elasticsearch_domain.es.endpoint }
EOF

echo "--- 3. Creating Root Files ---"

cat << 'EOF' > $BASE/variables.tf
variable "KKE_ENV" {}
variable "KKE_DYNAMODB_TABLE_NAME" {}
variable "KKE_SECRET_NAME" {}
variable "KKE_SECRET_VALUE" {}
variable "KKE_ELASTICSEARCH_DOMAIN" {}
EOF

cat << 'EOF' > $BASE/main.tf
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.KKE_DYNAMODB_TABLE_NAME
}
module "secretsmanager" {
  source       = "./modules/secretsmanager"
  secret_name  = var.KKE_SECRET_NAME
  secret_value = var.KKE_SECRET_VALUE
}
module "elasticsearch" {
  source      = "./modules/elasticsearch"
  domain_name = var.KKE_ELASTICSEARCH_DOMAIN
}
EOF

cat << 'EOF' > $BASE/outputs.tf
output "kke_table_name" { value = module.dynamodb.name }
output "kke_secret_arn" { value = module.secretsmanager.arn }
output "kke_elasticsearch_endpoint" { value = module.elasticsearch.endpoint }
EOF

echo "--- 4. Setting up Absolute Path Symlinks ---"
for ENV in dev prod; do
  TARGET="$BASE/env/$ENV"
  rm -f $TARGET/main.tf $TARGET/variables.tf $TARGET/outputs.tf $TARGET/modules
  ln -s $BASE/main.tf $TARGET/main.tf
  ln -s $BASE/variables.tf $TARGET/variables.tf
  ln -s $BASE/outputs.tf $TARGET/outputs.tf
  ln -s $BASE/modules $TARGET/modules
  touch $TARGET/terraform_config.tf
done

echo "--- 5. Creating tfvars files ---"

cat << 'EOF' > $BASE/env/dev/dev.tfvars
KKE_ENV                  = "dev"
KKE_DYNAMODB_TABLE_NAME  = "xfusion-dev-table"
KKE_SECRET_NAME          = "xfusion-dev-secret"
KKE_SECRET_VALUE         = "xfusion-dev-value"
KKE_ELASTICSEARCH_DOMAIN = "xfusion-dev-es"
EOF

cat << 'EOF' > $BASE/env/prod/prod.tfvars
KKE_ENV                  = "prod"
KKE_DYNAMODB_TABLE_NAME  = "xfusion-prod-table"
KKE_SECRET_NAME          = "xfusion-prod-secret"
KKE_SECRET_VALUE         = "xfusion-prod-value"
KKE_ELASTICSEARCH_DOMAIN = "xfusion-prod-es"
EOF

echo "--- Setup Finished Successfully! ---"
