[![Maintained by Uturn Data Solutions](https://img.shields.io/badge/maintained%20by-Uturn-%235849a6.svg)](https://uturndata.com/?ref=repo_rocketry)
# Rocketry Framework - Atlantis Module

This folder contains a [Terraform](https://www.terraform.io/) module to deploy Atlantis in [AWS](https://aws.amazon.com/).

This module is designed to deploy Atlantis on AWS ECS. It handles the setup of the ECS service, IAM roles, load balancer, SSM, and CloudWatch logs.

## Usage / Examples

Examples of usage of this module can be found in the `examples` folder.

<!-- Everything between the PRE-COMMIT-TERRAFORM DOCS HOOK tags is replaced whenever the pre-commit hook runs, edit custom docs outside the tags -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.5)

- <a name="requirement_aws"></a> [aws](#requirement\_aws) (~> 5.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Modules

The following Modules are called:

### <a name="module_public_loadbalancer"></a> [public\_loadbalancer](#module\_public\_loadbalancer)

Source: git@github.com:uturndata/rocketry_aws_load_balancer.git

Version: main

### <a name="module_execution_role"></a> [execution\_role](#module\_execution\_role)

Source: git@github.com:uturndata/rocketry_aws_iam_role.git

Version: main

### <a name="module_alb_listener_target"></a> [alb\_listener\_target](#module\_alb\_listener\_target)

Source: git@github.com:uturndata/rocketry_aws_alb_listener_target.git

Version: main

### <a name="module_task_role"></a> [task\_role](#module\_task\_role)

Source: git@github.com:uturndata/rocketry_aws_iam_role.git

Version: main

### <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service)

Source: git@github.com:uturndata/rocketry_aws_ecs_service.git

Version: main

### <a name="module_container_definition"></a> [container\_definition](#module\_container\_definition)

Source: cloudposse/ecs-container-definition/aws

Version: 0.60.0

## Resources

The following resources are used by this module:

- [aws_ssm_parameter.web_password](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) (resource)
- [random_password.web_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [aws_iam_policy_document.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_iam_policy_document.ssm_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) (data source)
- [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) (data source)
- [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) (data source)
- [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_service_name"></a> [service\_name](#input\_service\_name)

Description: Name of the ECS service to be created.

Type: `string`

### <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name)

Description: Name of the ECS cluster where the service will be deployed.

Type: `string`

### <a name="input_host_name"></a> [host\_name](#input\_host\_name)

Description: The fully qualified domain name (FQDN) for the Atlantis service. For example, 'atlantis.dev.example.com'.

Type: `string`

### <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn)

Description: The ARN of the SSL/TLS certificate used for securing the Atlantis host name.

Type: `string`

### <a name="input_gh_user"></a> [gh\_user](#input\_gh\_user)

Description: The GitHub username associated with the Atlantis instance.

Type: `string`

### <a name="input_gh_app_slug"></a> [gh\_app\_slug](#input\_gh\_app\_slug)

Description: The slug of the GitHub App.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id)

Description: The ID of the VPC where the ECS cluster is located.

Type: `string`

Default: `null`

### <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids)

Description: List of subnet IDs within the specified VPC where the ECS service will be deployed.

Type: `list(string)`

Default: `null`

### <a name="input_gh_hostname"></a> [gh\_hostname](#input\_gh\_hostname)

Description: The hostname of your GitHub Enterprise installation. Use 'github.com' for public GitHub.

Type: `string`

Default: `"github.com"`

### <a name="input_repo_allowlist"></a> [repo\_allowlist](#input\_repo\_allowlist)

Description: List of repositories that Atlantis is allowed to interact with.

Type: `list(string)`

Default:

```json
[
  "github.com/*"
]
```

### <a name="input_gh_team_allowlist"></a> [gh\_team\_allowlist](#input\_gh\_team\_allowlist)

Description: A comma-separated list of teams with their associated permissions on Atlantis commands. For example, 'myteam:plan, secteam:apply, DevOps Team:apply, DevOps Team:import'.

Type: `string`

Default: `null`

### <a name="input_gh_auth_app_installation"></a> [gh\_auth\_app\_installation](#input\_gh\_auth\_app\_installation)

Description: Configuration for authenticating Atlantis as a GitHub App. Ensure 'gh\_app\_id' and 'gh\_app\_key\_ssm\_suffix' are set if 'enabled' is true.

Type:

```hcl
object({
    enabled               = bool
    gh_app_id             = string
    gh_app_key_ssm_suffix = string
  })
```

Default:

```json
{
  "enabled": false,
  "gh_app_id": null,
  "gh_app_key_ssm_suffix": "/github/app_key"
}
```

### <a name="input_gh_allow_mergeable_bypass_apply"></a> [gh\_allow\_mergeable\_bypass\_apply](#input\_gh\_allow\_mergeable\_bypass\_apply)

Description: Allow pull requests that are mergeable to bypass the apply requirement.

Type: `bool`

Default: `false`

### <a name="input_ssm_prefix"></a> [ssm\_prefix](#input\_ssm\_prefix)

Description: The prefix for the SSM parameter. Defaults to '/ecs/{var.cluster\_name}/{var.service\_name}'.

Type: `string`

Default: `null`

### <a name="input_image_repo"></a> [image\_repo](#input\_image\_repo)

Description: The Docker image repository for Atlantis.

Type: `string`

Default: `"ghcr.io/runatlantis/atlantis"`

### <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag)

Description: The Docker image tag for Atlantis.

Type: `string`

Default: `"v0.25.0"`

### <a name="input_default_terraform_version"></a> [default\_terraform\_version](#input\_default\_terraform\_version)

Description: The default version of Terraform to use with Atlantis.

Type: `string`

Default: `"v1.5.5"`

### <a name="input_enable_web_basic_auth"></a> [enable\_web\_basic\_auth](#input\_enable\_web\_basic\_auth)

Description: Enable basic authentication for the Atlantis web interface.

Type: `bool`

Default: `true`

### <a name="input_web_username"></a> [web\_username](#input\_web\_username)

Description: The default username for accessing the Atlantis web interface when basic authentication is enabled.

Type: `string`

Default: `"atlantis"`

### <a name="input_secrets_names_suffixes"></a> [secrets\_names\_suffixes](#input\_secrets\_names\_suffixes)

Description: Suffixes for secret names stored in SSM.

Type:

```hcl
object({
    gh_token          = string
    gh_webhook_secret = string
    web_password      = string
  })
```

Default:

```json
{
  "gh_token": "/github/token",
  "gh_webhook_secret": "/github/webhook_secret",
  "web_password": "/web/password"
}
```

### <a name="input_repo_config_json"></a> [repo\_config\_json](#input\_repo\_config\_json)

Description: JSON configuration for repository settings in Atlantis.

Type: `string`

Default: `"{\n  \"repos\": [\n    {\n      \"id\": \"/.*/\",\n      \"apply_requirements\": [\"mergeable\"]\n    }\n  ]\n}\n"`

### <a name="input_checkout_strategy"></a> [checkout\_strategy](#input\_checkout\_strategy)

Description: Strategy for checking out code in Atlantis. Default is to merge locally before planning.

Type: `string`

Default: `"merge"`

### <a name="input_automerge"></a> [automerge](#input\_automerge)

Description: Automatically merge pull requests after plans have been successfully applied.

Type: `bool`

Default: `true`

### <a name="input_autoplan_modules"></a> [autoplan\_modules](#input\_autoplan\_modules)

Description: Automatically plan modules when changes are detected.

Type: `bool`

Default: `true`

### <a name="input_hide_prev_plan_comments"></a> [hide\_prev\_plan\_comments](#input\_hide\_prev\_plan\_comments)

Description: Hide previous plan comments in pull requests to reduce noise.

Type: `bool`

Default: `true`

### <a name="input_write_git_creds"></a> [write\_git\_creds](#input\_write\_git\_creds)

Description: Write Git credentials to allow Atlantis access to private modules.

Type: `bool`

Default: `true`

### <a name="input_emoji_reaction"></a> [emoji\_reaction](#input\_emoji\_reaction)

Description: Emoji used by Atlantis to react to comments in pull requests.

Type: `string`

Default: `"trident"`

### <a name="input_use_fargate"></a> [use\_fargate](#input\_use\_fargate)

Description: Use AWS Fargate for running the Atlantis ECS task.

Type: `bool`

Default: `true`

### <a name="input_cpu"></a> [cpu](#input\_cpu)

Description: The amount of CPU units to allocate for the Atlantis ECS task.

Type: `number`

Default: `512`

### <a name="input_memory"></a> [memory](#input\_memory)

Description: The amount of memory (in MiB) to allocate for the Atlantis ECS task.

Type: `number`

Default: `1024`

### <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count)

Description: The desired number of Atlantis tasks to run.

Type: `number`

Default: `1`

### <a name="input_policy_arns"></a> [policy\_arns](#input\_policy\_arns)

Description: A map of IAM policy ARNs to attach to the ECS service task role.

Type: `map(string)`

Default:

```json
{
  "AdministratorAccess": "arn:aws:iam::aws:policy/AdministratorAccess"
}
```

### <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags)

Description: Default tags to assign to Atlantis resources.

Type: `map(string)`

Default:

```json
{
  "Application": "Atlantis",
  "Environment": "development",
  "ManagedBy": "Terraform",
  "Team": "Uturn"
}
```

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License and disclaimer

*Legal info here*
