# Atlantis
output "url" {
  description = "The URL endpoint for Atlantis."
  value       = local.base_map_environment.ATLANTIS_ATLANTIS_URL
}

output "web_username" {
  description = "The username for Atlantis web access."
  value       = local.base_map_environment.ATLANTIS_WEB_USERNAME
}

output "web_password" {
  description = "The password for Atlantis web access. This is sensitive and should be kept secure."
  value       = var.enable_web_basic_auth ? random_password.web_password.result : null
  sensitive   = true
}

# ECS Service
output "service_name" {
  description = "The name of the ECS service."
  value       = module.ecs_service.name
}

output "service_id" {
  description = "The ID of the ECS service."
  value       = module.ecs_service.id
}

output "service_security_group_id" {
  description = "The security group ID associated with the ECS service."
  value       = module.ecs_service.security_group_id
}

# Network
output "vpc_id" {
  description = "The ID of the Virtual Private Cloud (VPC)."
  value       = local.vpc_id
}

output "subnet_ids" {
  description = "The IDs of the subnets within the VPC."
  value       = local.subnet_ids
}

# Load balancer
output "load_balancer_arn" {
  description = "The Amazon Resource Name (ARN) of the load balancer."
  value       = module.public_loadbalancer.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.public_loadbalancer.dns_name
}

output "load_balancer_listener_arns" {
  description = "The ARNs of the listeners for the load balancer."
  value       = module.public_loadbalancer.listener_arns
}

output "load_balancer_security_group_id" {
  description = "The security group ID associated with the load balancer."
  value       = module.public_loadbalancer.security_group_id
}

output "load_balancer_listener_target_group_arn" {
  description = "The ARN of the target group associated with the load balancer listener."
  value       = module.alb_listener_target.target_group_arn
}

output "load_balancer_listener_target_group_name" {
  description = "The name of the target group associated with the load balancer listener."
  value       = module.alb_listener_target.target_group_name
}

# Logging
output "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group."
  value       = module.cloudwatch_log-group.cloudwatch_log_group_name
}

output "cloudwatch_log_group_arn" {
  description = "The Amazon Resource Name (ARN) of the CloudWatch log group."
  value       = module.cloudwatch_log-group.cloudwatch_log_group_arn
}
