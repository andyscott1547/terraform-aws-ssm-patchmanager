# data

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "archive_file" "lambda" {
  for_each    = var.lambda_functions
  type        = "zip"
  source_file = "./src/critical_patching/${each.key}.py"
  output_path = "./src/critical_patching/${each.key}.zip"
}

data "aws_iam_policy_document" "lambda_critical_patching" {
  //checkov:skip=CKV_AWS_107
  //checkov:skip=CKV_AWS_110
  statement {
    sid    = "UpdatePatchBaselineSSMAllow"
    effect = "Allow"

    actions = [
      "ssm:ListAssociations",
      "ssm:StartAssociationsOnce",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_caller_identity.current.account_id}:${data.aws_region.current.name}:association/*"
    ]
  }

  statement {
    sid    = "UpdatePatchBaselineEC2Allow"
    effect = "Allow"

    actions = [
      "ec2:DescribeInstances",
      "ec2:DeleteTags",
      "ec2:CreateTags"
    ]

    resources = ["arn:aws:ec2:${data.aws_caller_identity.current.account_id}:${data.aws_region.current.name}:instance/*"]
  }
}

data "template_file" "step_function" {
  template = file("./files/step_function.json")
  vars = {
    update_baseline_lambda_arn = module.lambda["update_baseline_function"].lambda_arn
    revert_baseline_lambda_arn = module.lambda["revert_baseline_function"].lambda_arn
    apply_association_lambda_arn = module.lambda["apply_association_function"].lambda_arn
  }
}

data "aws_iam_policy_document" "assumerole" {
  statement {
    sid     = "AllowLambdaAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "step_function_critical_patching" {
  //checkov:skip=CKV_AWS_107
  //checkov:skip=CKV_AWS_110
  statement {
    sid    = "CriticalPatchingSSMAllow"
    effect = "Allow"

    actions = [
      "ssm:DescribeAssociationExecutions",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_caller_identity.current.account_id}:${data.aws_region.current.name}:association/*"
    ]
  }

  # statement {
  #   sid    = "CriticalPatchingXRayAllow"
  #   effect = "Allow"

  #   actions = [
  #     "xray:PutTraceSegments",
  #     "xray:PutTelemetryRecords",
  #     "xray:GetSamplingRules",
  #     "xray:GetSamplingTargets"
  #   ]

  #   resources = [
  #     "*"
  #   ]
  # }

  statement {
    sid    = "CriticalPatchingLambdaAllow"
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      "arn:aws:lambda:${data.aws_caller_identity.current.account_id}:${data.aws_region.current.name}:function:*"
    ]
  } 
}