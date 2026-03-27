output "kke_dynamodb_table_name" {
  value = aws_dynamodb_table.app_table.name
}

output "kke_sns_topic_arn" {
  value = aws_sns_topic.app_topic.arn
}

output "kke_ssm_parameter_name" {
  value = aws_ssm_parameter.app_config.name
}
