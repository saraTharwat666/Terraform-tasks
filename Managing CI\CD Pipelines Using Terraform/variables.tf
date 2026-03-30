mkdir -p /home/bob/terraform/modules/dynamodb
mkdir -p /home/bob/terraform/modules/secretsmanager
mkdir -p /home/bob/terraform/modules/elasticsearch
mkdir -p /home/bob/terraform/env/dev
mkdir -p /home/bob/terraform/env/prod

###############################################################################

// DynamoDB (modules/dynamodb/main.tf)
variable "table_name" {}
resource "aws_dynamodb_table" "table" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  attribute { name = "id"; type = "S" }
}
output "name" { value = aws_dynamodb_table.table.name }
  
// Secrets Manager (modules/secretsmanager/main.tf)
variable "secret_name" {}
variable "secret_value" {}
resource "aws_secretsmanager_secret" "secret" { name = var.secret_name }
resource "aws_secretsmanager_secret_version" "val" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = var.secret_value
}
output "arn" { value = aws_secretsmanager_secret.secret.arn }
  
// Elasticsearch (modules/elasticsearch/main.tf)
variable "domain_name" {}
resource "aws_elasticsearch_domain" "es" {
  domain_name           = var.domain_name
  elasticsearch_version = "7.10"
  cluster_config { instance_type = "t3.small.elasticsearch" }
}
output "endpoint" { value = aws_elasticsearch_domain.es.endpoint }
  
// (/home/bob/terraform/)
// variables.tf
variable "KKE_ENV" {}
variable "KKE_DYNAMODB_TABLE_NAME" {}
variable "KKE_SECRET_NAME" {}
variable "KKE_SECRET_VALUE" {}
variable "KKE_ELASTICSEARCH_DOMAIN" {}
  
// main.tf 
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
outputs.tf

Terraform
output "kke_table_name" { value = module.dynamodb.name }
output "kke_secret_arn" { value = module.secretsmanager.arn }
output "kke_elasticsearch_endpoint" { value = module.elasticsearch.endpoint }
