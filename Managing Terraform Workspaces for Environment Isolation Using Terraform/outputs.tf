output "kke_api_gateway_names" {
  value = aws_api_gateway_rest_api.kke_api[*].name
}

output "kke_log_group_names" {
  value = aws_cloudwatch_log_group.kke_log_group[*].name
}
