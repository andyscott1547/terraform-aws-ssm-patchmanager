# AWS Terraform SSM Patch Manager

Terraform module to create SSM patch manager baseline and automation.

- [Overview](#overview)
- [Terraform Docs](#terraform-docs)

## Overview

This module creates a patch baseline, SSM associations for the AWS-RunPatchBaseline automation document. Enables daily scans based on the baseline and also installs patches every 2 weeks by default.

## Terraform-Docs

<!-- BEGIN_TF_DOCS -->
#### Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.0 |
| aws | ~> 4.0 |

#### Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [aws_ssm_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_association) | resource |
| [aws_ssm_default_patch_baseline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_default_patch_baseline) | resource |
| [aws_ssm_maintenance_window.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window) | resource |
| [aws_ssm_maintenance_window_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target) | resource |
| [aws_ssm_maintenance_window_task.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task) | resource |
| [aws_ssm_patch_baseline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline) | resource |
| [aws_ssm_patch_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow_unassociated_targets | Allow unassociated targets | `bool` | `true` | no |
| approval_rules | Patch filters | <pre>list(object({<br>    approve_after_days  = number<br>    compliance_level    = string<br>    enable_non_security = bool<br>    patch_filters = list(object({<br>      key    = string<br>      values = list(string)<br>    }))<br>  }))</pre> | <pre>[<br>  {<br>    "approve_after_days": 7,<br>    "compliance_level": "HIGH",<br>    "enable_non_security": true,<br>    "patch_filters": [<br>      {<br>        "key": "CLASSIFICATION",<br>        "values": [<br>          "*"<br>        ]<br>      }<br>    ]<br>  }<br>]</pre> | no |
| approve_after_days | Number of days to approve patches after | `number` | `7` | no |
| approved_patches | List of approved patches | `list(string)` | `null` | no |
| compliance_level | Compliance level | `string` | `"CRITICAL"` | no |
| enable_non_security | Enable non-security patches | `bool` | `true` | no |
| env | Environment name | `string` | `"dev"` | no |
| global_filters | Global filters | <pre>list(object({<br>    key    = string<br>    values = list(string)<br>  }))</pre> | `[]` | no |
| install_schedule_expression | Schedule expression | `string` | `"cron(0 0 ? * THU#2 *)"` | no |
| is_default | Set as default patch baseline | `bool` | `true` | no |
| maint_window_cutoff | Maintenance window cutoff in hours | `number` | `1` | no |
| maint_window_duration | Maintenance window duration in hours | `number` | `6` | no |
| os | Operating system | `string` | `"REDHAT_ENTERPRISE_LINUX"` | no |
| output_location | Output location | <pre>list(object({<br>    output_s3_bucket_name = string<br>  }))</pre> | `[]` | no |
| rejected_patches | List of rejected patches | `list(string)` | `null` | no |
| scan_schedule_expression | Schedule expression | `string` | `"cron(15 23 ? * * *)"` | no |
| schedule_timezone | Schedule timezone | `string` | `"GB"` | no |
| wait_for_success_timeout_seconds | Wait for success timeout in seconds | `number` | `3600` | no |

#### Outputs

No outputs.
<!-- END_TF_DOCS -->
