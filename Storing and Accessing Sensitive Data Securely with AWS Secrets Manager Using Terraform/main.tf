resource "aws_secretsmanager_secret" "db_password" {
  name = "xfusion-db-password"
}


resource "aws_secretsmanager_secret_version" "db_password_val" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.KKE_DB_PASSWORD
}
