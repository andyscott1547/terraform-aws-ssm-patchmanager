# examples/multiple_os_custom/modules/ssm_maintenance_window/main.tf 

resource "aws_ssm_maintenance_window" "this" {
  name                       = lower("patch_baseline_install_${var.patch_day}_${var.patch_window}")
  schedule                   = "cron(${local.selected} 0 ? * ${var.patch_day} *)"
  duration                   = var.maint_window_duration
  cutoff                     = var.maint_window_cutoff
  allow_unassociated_targets = var.allow_unassociated_targets
  schedule_timezone          = var.schedule_timezone
}

resource "aws_ssm_maintenance_window_target" "this" {
  name          = lower("patch_baseline_install_${var.patch_day}_${var.patch_window}")
  window_id     = aws_ssm_maintenance_window.this.id
  resource_type = "INSTANCE"
  targets {
    key    = "tag:PatchWindow"
    values = ["${var.patch_day}_${var.patch_window}"]
  }
}


resource "aws_ssm_maintenance_window_task" "this" {
  name            = lower("patch_baseline_install_${var.patch_day}_${var.patch_window}")
  window_id       = aws_ssm_maintenance_window.this.id
  task_type       = "RUN_COMMAND"
  priority        = 1
  max_concurrency = 5
  max_errors      = 1
  task_arn        = "AWS-RunPatchBaseline"
  task_invocation_parameters {
    run_command_parameters {
      comment              = lower("Install patches for instances")
      output_s3_bucket     = var.output_location != null ? var.output_location[0].output_s3_bucket_name : null
      output_s3_key_prefix = var.output_location != null ? lower("${data.aws_caller_identity.current.id}/${data.aws_region.current.name}/install}") : null
      timeout_seconds      = 120

      parameter {
        name   = "Operation"
        values = ["Install"]
      }

      parameter {
        name   = "RebootOption"
        values = ["RebootIfNeeded"]
      }
    }
  }
  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.this.id]
  }
}
