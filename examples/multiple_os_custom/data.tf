# data

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "lambda_critical_patching" {
  //checkov:skip=CKV_AWS_107
  //checkov:skip=CKV_AWS_110
  statement {
    sid    = "UpdatePatchBaselineSSMAllow"
    effect = "Allow"

    actions = [
      "SSM:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "UpdatePatchBaselineEC2Allow"
    effect = "Allow"

    actions = [
      "EC2:*"
    ]

    resources = ["*"]
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
      "ssm:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "CriticalPatchingEC2Allow"
    effect = "Allow"

    actions = [
      "ec2:*"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CriticalPatchingXRayAllow"
    effect = "Allow"

    actions = [
      "xray:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid    = "CriticalPatchingLambdaAllow"
    effect = "Allow"

    actions = [
      "lambda:*"
    ]

    resources = [
      "*"
    ]
  } 
}