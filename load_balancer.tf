module "public_loadbalancer" {
  source = "git@github.com:uturndata/rocketry_aws_load_balancer.git?ref=main"

  name        = var.service_name
  type        = "application"
  target_type = "ip"

  vpc_id     = local.vpc_id
  subnet_ids = local.subnet_ids

  listener_actions = {
    "443" = {
      protocol        = "HTTPS"
      action          = "target"
      certificate_arn = local.certificate_arn
    }
  }

  allowed_cidrs = ["0.0.0.0/0"]
}

module "alb_listener_target" {
  source = "git@github.com:uturndata/rocketry_aws_alb_listener_target.git?ref=main"

  listener_arn = module.public_loadbalancer.listener_arns["443"]

  name                             = var.service_name
  target_type                      = "instance"
  host_names                       = local.host_names
  port                             = local.app_port
  protocol                         = "HTTP"
  stickiness                       = true
  deregistration_delay             = 30
  instance_ids                     = [] # Populated by the ECS module
  health_check_path                = "/healthz"
  health_check_port                = local.app_port
  health_check_protocol            = "HTTP"
  health_check_matcher             = "200"
  health_check_healthy_threshold   = 3
  health_check_unhealthy_threshold = 3
  health_check_timeout             = 10
  health_check_interval            = 30

  tags = local.default_tags
}
