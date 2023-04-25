# data

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "update_patch_baseline" {
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