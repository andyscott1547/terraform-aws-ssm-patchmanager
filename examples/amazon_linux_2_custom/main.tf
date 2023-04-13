# example/main

module "amazon_linux_2" {
  source     = "andyscott1547/ssm-patchmanager/aws"
  version    = "0.1.0"
  os         = "AMAZON_LINUX_2"
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
    },
    {
      approve_after_days  = 7,
      compliance_level    = "CRITICAL",
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