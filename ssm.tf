resource "random_password" "web_password" {
  length  = 24
  special = true
}

resource "aws_ssm_parameter" "web_password" {
  name  = "${local.ssm_prefix}/web/password"
  type  = "SecureString"
  value = random_password.web_password.result
}
