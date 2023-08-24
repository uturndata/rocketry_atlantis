module "ecs_service" {
  source = "git@github.com:uturndata/rocketry_aws_ecs_service.git?ref=v2.1.1"

  name                       = local.service_name
  cluster                    = local.cluster_name
  capacity_provider_strategy = local.capacity_provider_strategy
  ordered_placement_strategy = local.ordered_placement_strategy
  container_definitions      = [module.container_definition.json_map_encoded]
  enable_execute_command     = true
  force_new_deployment       = local.force_new_deployment
  requiresCompatibilities    = local.requiresCompatibilities
  launch_type                = local.launch_type

  execution_role_arn = module.ecs_task_execution_role.arn # "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  task_role_arn      = module.task_role.arn

  app_port                   = local.app_port
  desired_count              = local.desired_count
  cpu                        = local.cpu
  memory                     = local.memory
  vpc_id                     = local.vpc_id
  subnet_ids                 = local.subnet_ids["app"]
  allowed_cidrs              = local.allowed_cidrs
  allowed_security_group_ids = local.allowed_security_group_ids
  host_volumes               = local.host_volumes

  target_group_arns = local.target_group_arns

  template_task_definition = false
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.60.0"

  container_name  = local.container_name
  container_image = local.container_image_url

  healthcheck = {
    command     = ["curl", "-s", "-o", "/dev/null", "-w", "%%{http_code}", "http://localhost:4141/"]
    interval    = 60
    retries     = 5
    startPeriod = 60
    timeout     = 15
  }

  map_environment = local.map_environment
  map_secrets     = local.map_secrets

  port_mappings = [
    {
      containerPort = local.app_port
      hostPort      = local.app_port
      protocol      = "tcp"
    }
  ]

  user = "atlantis:atlantis"

  working_directory = "/home/atlantis"
}
