locals {
  cluster_name = "example-cluster"

  default_tags = {
    Application = "Atlantis"
    Team        = "Uturn"
    ManagedBy   = "Terraform"
    Environment = "development"
  }
}
