# example/main

module "standard_patch_baselines" {
  for_each                  = var.standard_os_baselines
  source                    = "andyscott1547/ssm-patchmanager/aws"
  version                   = "1.3.1"
  os                        = each.key
  is_default                = each.value.is_default
  approval_rules            = each.value.approval_rules
  enable_association        = false
  enable_maintenance_window = false
}

module "critical_patch_baselines" {
  for_each                  = var.critical_os_baselines
  source                    = "andyscott1547/ssm-patchmanager/aws"
  version                   = "1.3.1"
  os                        = each.key
  approval_rules            = each.value.approval_rules
  name_prefix               = "critical"
  enable_association        = true
  ssm_association           = ["Install"]
  critical                  = true
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

module "lambda" {
  for_each = var.lambda_functions
  source              = "./modules/lambda"
  lambda_name         = each.key
  code_zip            = aws_s3_object.object[each.key].key
  s3_bucket           = module.lambda_s3.bucket_name
  handler             = "${each.key}.lambda_handler"
  timeout             = each.value.timeout
  custom_policy       = data.aws_iam_policy_document.lambda_critical_patching.json
  environment_variables = {
    LOGGING_LEVEL = "INFO"
  }
  depends_on = [
    aws_s3_object.object
  ] 
}

data "archive_file" "lambda" {
  for_each    = var.lambda_functions
  type        = "zip"
  source_file = "./src/critical_patching/${each.key}.py"
  output_path = "./src/critical_patching/${each.key}.zip"
}

resource "aws_s3_object" "object" {
  for_each = var.lambda_functions
  bucket = module.lambda_s3.bucket_name
  key    = "${each.key}.zip"
  source = data.archive_file.lambda[each.key].output_path
  etag = filemd5(data.archive_file.lambda[each.key].output_path)
}

module "lambda_s3" {
  source      = "andyscott1547/compliant-s3-bucket/aws"
  version     = "1.0.0"
  bucket_name = "patchmanager-lambda"
}

resource "aws_sfn_state_machine" "critical_patching" {
  name        = "critical-patching"
  role_arn    = aws_iam_role.critical_patching.arn
  definition  = data.template_file.step_function.rendered
}

resource "aws_iam_role" "critical_patching" {
  name = "step-function-role"

  assume_role_policy = data.aws_iam_policy_document.assumerole.json

  tags = merge(
    {
      "Name" = "step-function-role",
    },
  )
}

resource "aws_iam_role_policy" "critical_patching" {
  name   = "critical-patching-custom-policy"
  role   = aws_iam_role.critical_patching.name
  policy = data.aws_iam_policy_document.step_function_critical_patching.json
}
