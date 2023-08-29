data "aws_iam_policy_document" "execution_role" {
  # Access SSM Parameters
  statement {
    actions   = ["ssm:GetParameters"]
    resources = ["arn:aws:ssm:*:*:parameter/${local.ssm_prefix}/*"]
  }

  # Logging Permissions
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = [
      "arn:aws:logs:*:*:log-group:${local.cloudwatch_logs_name}:*"
    ]
  }
}

module "execution_role" {
  source = "git@github.com:uturndata/rocketry_aws_iam_role.git?ref=main"

  name                 = "${var.service_name}-TaskExecutionRole"
  path                 = "/ecs/"
  description          = "Access for ECS Agent to call AWS services"
  assume_role_services = ["ecs-tasks.amazonaws.com"]

  policy_arns = {
    AmazonECSTaskExecutionRolePolicy = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  }

  inline_policies = {
    ExecutionRole = data.aws_iam_policy_document.execution_role.json
  }
}

data "aws_iam_policy_document" "ssm_access" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "logs_access" {
  statement {
    actions = [
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:log-group:${local.cloudwatch_logs_name}:*"]
  }
}

module "task_role" {
  source = "git@github.com:uturndata/rocketry_aws_iam_role.git?ref=main"

  name                 = "${var.service_name}-TaskRole"
  path                 = "/ecs/"
  description          = "Access for ${var.service_name} ECS service tasks"
  assume_role_services = ["ecs-tasks.amazonaws.com"]

  policy_arns = local.policy_arns

  inline_policies = {
    ssm-access  = data.aws_iam_policy_document.ssm_access.json
    logs-access = data.aws_iam_policy_document.logs_access.json
  }
}
