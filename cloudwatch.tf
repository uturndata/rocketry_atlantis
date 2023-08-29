module "cloudwatch_log-group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "4.3.0"

  create            = true
  name              = local.cloudwatch_logs_name
  retention_in_days = local.cloudwatch_logs_retention_days

  tags = local.default_tags
}
