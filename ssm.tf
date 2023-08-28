resource "random_password" "web_password" {
  length  = 24
  special = true
}

resource "aws_ssm_parameter" "web_password" {
  name  = "${local.ssm_prefix}${var.secrets_names_suffixes.web_password}"
  type  = "SecureString"
  value = random_password.web_password.result
}
