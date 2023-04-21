# example/main

module "standard_patch_baselines" {
  for_each       = var.standard_os_baselines
  source         = "andyscott1547/ssm-patchmanager/aws"
  version        = "1.1.4"
  os             = each.key
  is_default     = each.value.is_default
  approval_rules = each.value.approval_rules
}

module "standard_patch_baselines" {
  for_each                  = var.critical_os_baselines
  source                    = "andyscott1547/ssm-patchmanager/aws"
  version                   = "1.1.4"
  os                        = each.key
  approval_rules            = each.value.approval_rules
  name_prefix               = "critical"
  enable_association        = false
  enable_maintenance_window = false
}