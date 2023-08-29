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

variable "host_name" {
  type        = string
  description = "The fully qualified domain name (FQDN) for the Atlantis service. For example, 'atlantis.dev.example.com'."
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the SSL/TLS certificate used for securing the Atlantis host name."
}

variable "repo_platform" {
  description = "The repository platform being used by Atlantis. So far, only `github` is supported by this module."
  type        = string

  validation {
    condition     = contains(["github"], var.repo_platform)
    error_message = "The repo_platform value must be one of: github."
  }
}

variable "repo_allowlist" {
  description = "List of repositories that Atlantis is allowed to interact with."
  type        = list(string)
  default     = ["github.com/*"]
}

variable "gh_hostname" {
  description = "The hostname of your GitHub Enterprise installation. Use 'github.com' for public GitHub."
  type        = string
  default     = "github.com"
}

variable "gh_user" {
  description = "The GitHub username associated with the Atlantis instance."
  type        = string
}

variable "gh_app_slug" {
  description = "The slug of the GitHub App."
  type        = string
}

variable "gh_team_allowlist" {
  description = "A comma-separated list of teams with their associated permissions on Atlantis commands. For example, 'myteam:plan, secteam:apply, DevOps Team:apply, DevOps Team:import'."
  type        = string
  default     = null
}

variable "gh_auth_app_installation" {
  description = "Configuration for authenticating Atlantis as a GitHub App. Ensure 'gh_app_id' and 'gh_app_key_ssm_suffix' are set if 'enabled' is true."
  type = object({
    enabled   = bool
    gh_app_id = string
  })

  default = {
    enabled   = false
    gh_app_id = null
  }

  validation {
    condition     = var.gh_auth_app_installation.enabled == false || (var.gh_auth_app_installation.enabled == true && var.gh_auth_app_installation.gh_app_id != null)
    error_message = "If gh_auth_app_installation.enabled is true, gh_app_id must be set."
  }
}

variable "gh_allow_mergeable_bypass_apply" {
  description = "Allow pull requests that are mergeable to bypass the apply requirement."
  type        = bool
  default     = false
}

variable "ssm_prefix" {
  description = "The prefix for the SSM parameter. Defaults to '/ecs/{var.cluster_name}/{var.service_name}'."
  type        = string
  default     = null
}

variable "image_repo" {
  description = "The Docker image repository for Atlantis."
  type        = string
  default     = "ghcr.io/runatlantis/atlantis"
}

variable "image_tag" {
  description = "The Docker image tag for Atlantis."
  type        = string
  default     = "v0.25.0"
}

variable "default_terraform_version" {
  description = "The default version of Terraform to use with Atlantis."
  type        = string
  default     = "v1.5.5"
}

variable "enable_web_basic_auth" {
  description = "Enable basic authentication for the Atlantis web interface."
  type        = bool
  default     = true
}

variable "web_username" {
  description = "The default username for accessing the Atlantis web interface when basic authentication is enabled."
  type        = string
  default     = "atlantis"
}

variable "repo_config_json" {
  description = "JSON configuration for repository settings in Atlantis."
  type        = string
  default     = <<-EOT
    {
      "repos": [
        {
          "id": "/.*/",
          "apply_requirements": ["mergeable"]
        }
      ]
    }
    EOT
}

variable "checkout_strategy" {
  description = "Strategy for checking out code in Atlantis. Default is to merge locally before planning."
  type        = string
  default     = "merge"
}

variable "automerge" {
  description = "Automatically merge pull requests after plans have been successfully applied."
  type        = bool
  default     = true
}

variable "autoplan_modules" {
  description = "Automatically plan modules when changes are detected."
  type        = bool
  default     = true
}

variable "hide_prev_plan_comments" {
  description = "Hide previous plan comments in pull requests to reduce noise."
  type        = bool
  default     = true
}

variable "write_git_creds" {
  description = "Write Git credentials to allow Atlantis access to private modules."
  type        = bool
  default     = true
}

variable "emoji_reaction" {
  description = "Emoji used by Atlantis to react to comments in pull requests."
  type        = string
  default     = "trident"
}

variable "use_fargate" {
  description = "Use AWS Fargate for running the Atlantis ECS task."
  type        = bool
  default     = true
}

variable "cpu" {
  description = "The amount of CPU units to allocate for the Atlantis ECS task."
  type        = number
  default     = 512
}

variable "memory" {
  description = "The amount of memory (in MiB) to allocate for the Atlantis ECS task."
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "The desired number of Atlantis tasks to run."
  type        = number
  default     = 1
}

variable "policy_arns" {
  description = "A map of IAM policy ARNs to attach to the ECS service task role."
  type        = map(string)
  default = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

variable "cloudwatch_logs_retention_days" {
  description = "For how many days the logs will be kept in CloudWatch."
  type        = number
  default     = 90
}

variable "default_tags" {
  description = "Default tags to assign to Atlantis resources."
  type        = map(string)
  default = {
    Application = "Atlantis"
    Team        = "Uturn"
    ManagedBy   = "Terraform"
    Environment = "development"
  }
}
