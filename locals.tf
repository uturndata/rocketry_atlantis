locals {
  region = data.aws_region.current.name
  # region_short = join("", regex("(\\w\\w)-(\\w)\\w+-(\\d)", local.region))

  subnet_ids = coalesce(var.subnet_ids, data.aws_subnets.default.ids)
  vpc_id     = coalesce(var.vpc_id, data.aws_vpc.default.id)

  default_tags = var.default_tags

  # Atlantis Configuration
  image_url = "${var.image_repo}:${var.image_tag}"

  base_map_environment = {
    # Required
    ATLANTIS_ATLANTIS_URL     = "https://${var.host_name}"
    ATLANTIS_REPO_ALLOWLIST   = join(",", var.repo_allowlist)
    DEFAULT_TERRAFORM_VERSION = var.default_terraform_version

    # Optional Config
    ATLANTIS_WEB_BASIC_AUTH = var.enable_web_basic_auth
    ATLANTIS_WEB_USERNAME   = var.enable_web_basic_auth ? var.web_username : null

    ATLANTIS_REPO_CONFIG_JSON = jsonencode(var.repo_config_json)

    ATLANTIS_CHECKOUT_STRATEGY       = var.checkout_strategy
    ATLANTIS_AUTOMERGE               = var.automerge
    ATLANTIS_AUTOPLAN_MODULES        = var.autoplan_modules
    ATLANTIS_HIDE_PREV_PLAN_COMMENTS = var.hide_prev_plan_comments
    ATLANTIS_WRITE_GIT_CREDS         = var.write_git_creds

    ATLANTIS_EMOJI_REACTION = var.emoji_reaction
  }

  # Repo platform specific environment
  map_environment = merge(local.base_map_environment,
    var.repo_platform == "github" ? {
      ATLANTIS_GH_USER                         = var.gh_user
      ATLANTIS_GH_APP_ID                       = var.gh_auth_app_installation.enabled ? var.gh_auth_app_installation.atlantis_gh_app_id : null
      ATLANTIS_GH_APP_SLUG                     = var.gh_app_slug
      ATLANTIS_GH_ALLOW_MERGEABLE_BYPASS_APPLY = var.gh_allow_mergeable_bypass_apply
      ATLANTIS_GH_HOSTNAME                     = var.gh_hostname
      ATLANTIS_GH_TEAM_ALLOWLIST               = var.gh_team_allowlist
    } : {}
  )

  base_map_secrets = {
    ATLANTIS_WEB_PASSWORD = var.enable_web_basic_auth ? "${local.ssm_prefix}/web/password" : null
  }

  # Repo platform specific secrets
  map_secrets = merge(local.base_map_secrets,
    var.repo_platform == "github" ? {
      ATLANTIS_GH_TOKEN          = "${local.ssm_prefix}/github/token"
      ATLANTIS_GH_WEBHOOK_SECRET = "${local.ssm_prefix}/github/webhook_secret"
      ATLANTIS_GH_APP_KEY        = var.gh_auth_app_installation.enabled ? "${local.ssm_prefix}/github/app_key" : null
    } : {}
  )

  # Environments and Secrets
  ssm_prefix = coalesce(var.ssm_prefix, "/ecs/${var.cluster_name}/${var.service_name}")

  # ECS Service Configuration
  service_name = var.service_name

  container_name      = local.service_name
  container_image_url = local.image_url

  cpu           = var.cpu
  memory        = var.memory
  desired_count = var.desired_count
  app_port      = 4141
  host_volumes  = []

  cluster_name               = var.cluster_name
  force_new_deployment       = true
  capacity_provider_strategy = []
  ordered_placement_strategy = []

  policy_arns = var.policy_arns

  # Launch Type Configuration
  use_fargate = var.use_fargate
  # Automatically calculated based on the above
  launch_type             = local.use_fargate && length(local.capacity_provider_strategy) == 0 ? "FARGATE" : null
  requiresCompatibilities = local.use_fargate ? ["FARGATE"] : ["EC2"]

  # CloudWatch Logs
  cloudwatch_logs_name           = "/ecs/${local.service_name}"
  cloudwatch_logs_retention_days = var.cloudwatch_logs_retention_days

  # Security Group Configuration
  allowed_cidrs              = []
  allowed_security_group_ids = [module.public_loadbalancer.security_group_id]

  # ALB Pattern
  host_names        = [var.host_name]
  target_group_arns = [module.alb_listener_target.target_group_arn]
  certificate_arn   = var.certificate_arn
}
