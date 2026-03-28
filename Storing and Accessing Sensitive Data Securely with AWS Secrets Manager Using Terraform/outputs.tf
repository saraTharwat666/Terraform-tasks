output "kke_secret_arn" {
  value = aws_secretsmanager_secret.db_password.arn
}

output "kke_secret_string" {
  value     = aws_secretsmanager_secret_version.db_password_val.secret_string
  sensitive = true
}
