# example/main

module "standard_patch_baselines" {
  for_each                  = var.standard_os_baselines
  source                    = "andyscott1547/ssm-patchmanager/aws"
  version                   = "1.2.0"
  os                        = each.key
  is_default                = each.value.is_default
  approval_rules            = each.value.approval_rules
  enable_association        = false
  enable_maintenance_window = false
}

module "critical_patch_baselines" {
  for_each                  = var.critical_os_baselines
  source                    = "andyscott1547/ssm-patchmanager/aws"
  version                   = "1.2.0"
  os                        = each.key
  approval_rules            = each.value.approval_rules
  name_prefix               = "critical"
  enable_association        = false
  enable_maintenance_window = false
}

resource "aws_ssm_association" "default" {
  for_each         = toset(local.ssm_association)
  name             = "AWS-RunPatchBaseline"
  association_name = lower("all_os_patch_baseline_${each.value}")
  # wait_for_success_timeout_seconds = var.wait_for_success_timeout_seconds
  schedule_expression         = each.value == "Scan" ? var.scan_schedule_expression : null
  apply_only_at_cron_interval = each.value == "Scan" ? true : null

  dynamic "output_location" {
    for_each = var.output_location
    content {
      s3_bucket_name = output_location.value.output_s3_bucket_name
      s3_key_prefix  = lower("${data.aws_caller_identity.current.id}/${data.aws_region.current.name}/${each.value}}")
    }
  }

  parameters = {
    Operation    = each.value
    RebootOption = each.value == "Install" ? "RebootIfNeeded" : null
  }

  targets {
    key    = "InstanceIds"
    values = ["*"]
  }
}

module "ssm_maintenance_window" {
  for_each     = local.patch_windows
  source       = "./modules/ssm_maintenance_window"
  patch_day    = each.value.day
  patch_window = each.value.period
}