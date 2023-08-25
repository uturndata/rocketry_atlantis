locals {
  account      = "uturn-rocketry"
  region       = "us-east-2"
  region_short = join("", regex("(\\w\\w)-(\\w)\\w+-(\\d)", local.region))

  account_id = "118504845376"


  subnet_ids = coalesce(var.subnet_ids, data.aws_subnets.default.ids)
  vpc_id     = coalesce(var.vpc_id, data.aws_vpc.default.id)

  default_tags = {
    Application = "Atlantis"
    Team        = "Uturn"
    ManagedBy   = "Terraform"
    Environment = "development"
  }

  # Atlantis Configuration
  atlantis_version = "v0.25.0"

  map_environment = {
    # Required
    ATLANTIS_ATLANTIS_URL     = "PLACEHOLDER" # "https://atlantis.dev.example.com"
    ATLANTIS_REPO_ALLOWLIST   = join(",", ["github.com/uturndata/rocketry_*"])
    DEFAULT_TERRAFORM_VERSION = "1.3.9"

    # Optional Config
    ATLANTIS_WEB_BASIC_AUTH = true
    ATLANTIS_WEB_USERNAME   = "atlantis"

    ATLANTIS_REPO_CONFIG_JSON = jsonencode({
      repos = [{
        id                 = "/.*/"
        apply_requirements = ["mergeable"]
      }]
    })

    ATLANTIS_CHECKOUT_STRATEGY       = "merge" # Merge locally before planning
    ATLANTIS_AUTOMERGE               = true    # After apply, merge down
    ATLANTIS_AUTOPLAN_MODULES        = true
    ATLANTIS_HIDE_PREV_PLAN_COMMENTS = true
    ATLANTIS_WRITE_GIT_CREDS         = true # Allow access to private modules

    ATLANTIS_EMOJI_REACTION = "trident"

    # GitHub Config
    ATLANTIS_GH_USER                         = "PLACEHOLDER"
    ATLANTIS_GH_ORG                          = "uturndata"
    ATLANTIS_GH_APP_ID                       = "PLACEHOLDER"
    ATLANTIS_GH_APP_SLUG                     = "atlantis-app"
    ATLANTIS_GH_ALLOW_MERGEABLE_BYPASS_APPLY = false
    # ATLANTIS_GH_HOSTNAME                   = "my.github.enterprise.com" # GitHub Enterprise only
    # ATLANTIS_GH_TEAM_ALLOWLIST             = "myteam:plan, secteam:apply, DevOps Team:apply, DevOps Team:import"
    # ATLANTIS_GH_APP_KEY_FILE               = "PLACEHOLDER" # Using ATLANTIS_GH_APP_KEY
  }

  map_secrets = { for k, v in {
    ATLANTIS_GH_TOKEN          = "/github/token"
    ATLANTIS_GH_WEBHOOK_SECRET = "/github/webhook_secret" # See https://docs.github.com/en/developers/webhooks-and-events/webhooks/securing-your-webhooks
    ATLANTIS_GH_APP_KEY        = "/github/app_key"
    ATLANTIS_WEB_PASSWORD      = "/web/password"
  } : k => "${local.ssm_prefix}${v}" }

  # Environments and Secrets
  ssm_prefix = "/ecs/${var.cluster_name}/${var.service_name}"

  # ECS Service Configuration
  service_name = var.service_name

  container_name      = local.service_name
  container_image_url = "ghcr.io/runatlantis/atlantis:${local.atlantis_version}"

  cpu           = 512
  memory        = 1024
  desired_count = 1
  app_port      = 4141
  host_volumes  = []

  cluster_name               = var.cluster_name
  force_new_deployment       = true
  capacity_provider_strategy = []
  ordered_placement_strategy = []

  policy_arns = { # A map of IAM policy arns
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  iam_inline_policies = { # A map of IAM inline policies
    ssm-access = data.aws_iam_policy_document.ssm_access.json
  }

  # Launch Type Configuration
  use_fargate = true
  # Automatically calculated based on the above
  launch_type             = local.use_fargate && length(local.capacity_provider_strategy) == 0 ? "FARGATE" : null
  requiresCompatibilities = local.use_fargate ? ["FARGATE"] : ["EC2"]

  # CloudWatch Logs
  cloudwatch_logs_name           = "/ecs/${local.service_name}"
  cloudwatch_logs_retention_days = 90

  # Security Group Configuration
  allowed_cidrs              = []
  allowed_security_group_ids = [module.public_loadbalancer.security_group_id]

  # ALB Pattern
  host_names        = ["PLACEHOLDER"] # ["atlantis.dev.example.com"]
  target_group_arns = [module.alb_listener_target.target_group_arn]
  listener_arn      = module.public_loadbalancer.listener_arns["443"]
  certificate_arn   = "PLACEHOLDER" # "arn:aws:acm:<region>:<account-id>:certificate/<cert-id>"
}
