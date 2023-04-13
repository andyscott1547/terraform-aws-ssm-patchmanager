# example/main

module "patchmanager_windows" {
  source           = "andyscott1547/ssm-patchmanager/aws"
  version          = "0.1.0"
  os               = "WINDOWS"
  is_default       = false
  rejected_patches = ["KB2006634"]

  global_filters = [
    {
      key    = "MSRC_SEVERITY",
      values = ["Low"]
    }
  ]

  approval_rules = [
    {
      approve_after_days  = 7,
      compliance_level    = "HIGH",
      enable_non_security = false #windows does not support this value
      patch_filters = [
        {
          key    = "PRODUCT",
          values = ["WindowsServer2019"]
        },
        {
          key    = "CLASSIFICATION",
          values = ["CriticalUpdates", "SecurityUpdates", "Updates"]
        },
        {
          key    = "MSRC_SEVERITY",
          values = ["Critical", "Important", "Moderate"]
        }
      ]
    }
  ]
}
