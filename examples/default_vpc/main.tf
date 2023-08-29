module "example-atlantis" {
  source = "../../"

  service_name = "atlantis"
  cluster_name = aws_ecs_cluster.example.name

  host_name = "atlantis.dev.example.com"
  certificate_arn = "arn:aws:acm:region:account:certificate/certificate_ID"

  repo_platform = "github"
  gh_user = "rocketry-atlantis"
  gh_app_slug = "atlantis-app"

  default_tags = local.default_tags
}
