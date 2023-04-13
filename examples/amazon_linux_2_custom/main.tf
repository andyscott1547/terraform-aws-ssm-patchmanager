# example/main

module "amazon_linux_2" {
  source     = "github.com/andyscott1547/terraform-aws-ssm-patchmanager"
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