variable "service_name" {
  type        = string
  description = "Name of the Service to create"
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS Cluster to create"
}

variable "vpc_id" {
  type        = string
  description = "ID of the cluster's VPC"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs from the VPC"
  default     = null
}
