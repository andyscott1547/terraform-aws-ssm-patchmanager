# example/main

module "standard_patch_baselines" {
  for_each       = var.operating_systems
  source         = "andyscott1547/ssm-patchmanager/aws"
  version        = "1.1.2"
  os             = each.key
  is_default     = each.value.is_default
  approval_rules = each.value.approval_rules
}