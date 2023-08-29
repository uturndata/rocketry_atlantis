# Typically, your Cluster and Service will not be in the same project
# But it is included here for example purposes
resource "aws_ecs_cluster" "example" {
  name = local.cluster_name
}
