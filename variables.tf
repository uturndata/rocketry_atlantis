variable "service_name" {
  type        = string
  description = "Name of the ECS service to be created."
}

variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster where the service will be deployed."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the ECS cluster is located."
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs within the specified VPC where the ECS service will be deployed."
  default     = null
}

variable "atlantis_host_name" {
  type        = string
  description = "The fully qualified domain name (FQDN) for the Atlantis service. For example, 'atlantis.dev.example.com'."
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the SSL/TLS certificate used for securing the Atlantis host name."
}

variable "atlantis_gh_hostname" {
  description = "The hostname of your GitHub Enterprise installation. Use 'github.com' for public GitHub."
  type        = string
  default     = "github.com"
}

variable "atlantis_repo_whitelist" {
  description = "List of repositories that Atlantis is allowed to interact with."
  type        = list(string)
  default     = ["github.com/*"]
}

variable "atlantis_gh_user" {
  description = "The GitHub username associated with the Atlantis instance."
  type        = string
}

variable "atlantis_gh_app_slug" {
  description = "The slug of the GitHub App."
  type        = string
}

variable "atlantis_gh_team_allowlist" {
  description = "A comma-separated list of teams with their associated permissions on Atlantis commands. For example, 'myteam:plan, secteam:apply, DevOps Team:apply, DevOps Team:import'."
  type        = string
  default     = null
}

variable "atlantis_gh_authentication_app_installation" {
  description = "Configuration for authenticating Atlantis as a GitHub App. Ensure 'atlantis_gh_app_id' is set if 'enabled' is true."
  type = object({
    enabled            = bool
    atlantis_gh_app_id = string
  })

  default = {
    enabled            = false
    atlantis_gh_app_id = null
  }

  validation {
    condition     = var.atlantis_gh_authentication_app_installation.enabled == false || (var.atlantis_gh_authentication_app_installation.enabled == true && var.atlantis_gh_authentication_app_installation.atlantis_gh_app_id != null)
    error_message = "If atlantis_gh_authentication_app_installation.enabled is true, atlantis_gh_app_id must be set."
  }
}
