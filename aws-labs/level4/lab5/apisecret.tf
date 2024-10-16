resource "aws_secretsmanager_secret" "kodek_api_key" {
  name        = "${var.project_name}-api-key-secret-${var.v}"
  description = "API key for ${var.project_name}"
}

resource "aws_secretsmanager_secret_version" "kodek_api_key_version" {
  secret_id     = aws_secretsmanager_secret.kodek_api_key.id
  secret_string = jsonencode({
    API_KEY_SECRET_NAME = "${var.api_key}"
  })
}

output "secret_arn" {
  value = aws_secretsmanager_secret.kodek_api_key.arn
}
