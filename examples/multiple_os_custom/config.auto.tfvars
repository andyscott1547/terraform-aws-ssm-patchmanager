# example/tfvars

region = "eu-west-1"

tags = {
  "Project"    = "example"
  "Owner"      = "example"
  "Billing_ID" = "000"
}
operating_systems = {
  AMAZON_LINUX_2 = {
    is_default = false
    approval_rules = [
      {
        approve_after_days  = 14,
        compliance_level    = "MEDIUM",
        enable_non_security = true,
        patch_filters = [
          {
            key    = "CLASSIFICATION",
            values = ["*"]
          },
          {
            key    = "SEVERITY",
            values = ["*"]
          }
        ]
      }
    ]
  }
}