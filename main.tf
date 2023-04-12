# main

resource "aws_ssm_patch_baseline" "this" {
  name             = lower("${var.env}_${var.os}_patch_baseline")
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
    for_each = var.approval_rules
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
}

resource "aws_ssm_default_patch_baseline" "this" {
  count            = var.is_default ? 1 : 0
  baseline_id      = aws_ssm_patch_baseline.this.id
  operating_system = aws_ssm_patch_baseline.this.operating_system
}

resource "aws_ssm_patch_group" "this" {
  baseline_id = aws_ssm_patch_baseline.this.id
  patch_group = var.os
}

resource "aws_ssm_association" "scan" {
  name                             = "AWS-RunPatchBaseline"
  association_name                 = lower("${var.env}_${var.os}_patch_baseline_scan")
  wait_for_success_timeout_seconds = var.wait_for_success_timeout_seconds
  schedule_expression              = var.schedule_expression
  dynamic "output_location" {
    for_each = var.output_location
    content {
      s3_bucket_name = output_location.value.output_s3_bucket_name
      s3_key_prefix  = output_location.value.output_s3_key_prefix
    }
  }

  parameters = {
    Operation = "Scan"
  }

  targets {
    key    = "tag:Patch Group"
    values = [var.os]
  }
}