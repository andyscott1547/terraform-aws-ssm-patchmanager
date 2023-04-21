# main

resource "aws_ssm_patch_baseline" "this" {
  name             = lower("${var.name_prefix}_${var.os}_patch_baseline")
  description      = "Patch baseline for ${var.env} ${var.os} instances"
  operating_system = upper(var.os)
  rejected_patches = var.rejected_patches
  approved_patches = var.approved_patches

  dynamic "global_filter" {
    for_each = var.global_filters
    content {
      key    = global_filter.value.key
      values = global_filter.value.values
    }
  }

  dynamic "approval_rule" {
    for_each = var.approved_patches != null ? [] : var.approval_rules
    content {
      approve_after_days  = approval_rule.value.approve_after_days
      compliance_level    = approval_rule.value.compliance_level
      enable_non_security = approval_rule.value.enable_non_security
      dynamic "patch_filter" {
        for_each = approval_rule.value.patch_filters
        content {
          key    = patch_filter.value.key
          values = patch_filter.value.values
        }
      }
    }
  }
  dynamic "source" {
    for_each = var.repo_source
    content {
      name          = source.value.name
      configuration = source.value.configuration
      products      = source.value.products
    }
  }
}

resource "aws_ssm_default_patch_baseline" "this" {
  count            = var.is_default ? 1 : 0
  baseline_id      = aws_ssm_patch_baseline.this.id
  operating_system = aws_ssm_patch_baseline.this.operating_system
}

resource "aws_ssm_patch_group" "this" {
  count       = var.is_default ? 0 : 1
  baseline_id = aws_ssm_patch_baseline.this.id
  patch_group = var.os
}

resource "aws_ssm_association" "this" {
  for_each                         = var.enable_association ? toset(local.ssm_association) : []
  name                             = "AWS-RunPatchBaseline"
  association_name                 = lower("${var.os}_patch_baseline_${each.value}")
  wait_for_success_timeout_seconds = var.wait_for_success_timeout_seconds
  schedule_expression              = each.value == "Scan" ? var.scan_schedule_expression : null
  dynamic "output_location" {
    for_each = var.output_location
    content {
      s3_bucket_name = output_location.value.output_s3_bucket_name
      s3_key_prefix  = lower("${data.aws_caller_identity.current.id}/${data.aws_region.current.name}/${var.os}/${each.value}}")
    }
  }

  parameters = {
    Operation    = each.value
    RebootOption = each.value == "Install" ? "RebootIfNeeded" : null
  }

  targets {
    key    = "tag:PatchGroup"
    values = [var.os]
  }
}

resource "aws_ssm_maintenance_window" "this" {
  count                      = var.enable_maintenance_window ? 1 : 0
  name                       = lower("${var.os}_patch_baseline_install")
  schedule                   = var.install_schedule_expression
  duration                   = var.maint_window_duration
  cutoff                     = var.maint_window_cutoff
  allow_unassociated_targets = var.allow_unassociated_targets
  schedule_timezone          = var.schedule_timezone
}

resource "aws_ssm_maintenance_window_target" "this" {
  count         = var.enable_maintenance_window ? 1 : 0
  name          = lower("${var.os}_patch_baseline_install")
  window_id     = aws_ssm_maintenance_window.this[0].id
  resource_type = "INSTANCE"
  targets {
    key    = "tag:PatchGroup"
    values = [var.os]
  }
}

resource "aws_ssm_maintenance_window_task" "this" {
  count           = var.enable_maintenance_window ? 1 : 0
  name            = lower("${var.os}_patch_baseline_install")
  window_id       = aws_ssm_maintenance_window.this[0].id
  task_type       = "RUN_COMMAND"
  priority        = 1
  max_concurrency = 5
  max_errors      = 1
  task_arn        = "AWS-RunPatchBaseline"
  task_invocation_parameters {
    run_command_parameters {
      comment              = lower("Install patches for ${var.env} ${var.os} instances")
      output_s3_bucket     = length(var.output_location) != 0 ? var.output_location[0].output_s3_bucket_name : null
      output_s3_key_prefix = length(var.output_location) != 0 ? lower("${data.aws_caller_identity.current.id}/${data.aws_region.current.name}/${var.os}/install}") : null
      timeout_seconds      = 120

      parameter {
        name   = "Operation"
        values = ["Install"]
      }
    }
  }
  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.this[0].id]
  }
}
