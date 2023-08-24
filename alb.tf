# module.public_loadbalancer
# security_group_id
# listener_arns
# certificate_arn

module "public_loadbalancer" {
  source = "git@github.com:uturndata/rocketry_aws_load_balancer.git?ref=v3.0.0"
}

# module.alb_listener_target
# target_group_arn

module "alb_listener_target" {
  source = "git@github.com:uturndata/rocketry_aws_alb_listener_target.git?ref=v2.1.2"
}
