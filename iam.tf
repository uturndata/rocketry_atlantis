# data.aws_iam_policy_document.ssm_access
  # Permissions to fetch secrets from parameter store goes here

# module.ecs_task_execution_role.arn
  # role for the ECS agent, to manage and run the container
  # ECR and CloudWatch permissions goes here

# module.task_role
  # role for the app running inside the container.
  # ssm inline policy goes here
  # other needed permissions for atlantis (s3, lambda, sqs, apigateway...)

# Check examples/advances_fargate under rocketry_aws_ecs_service
