# example/main

module "amazon_linux_2" {
  for_each       = var.operating_systems
  source         = "andyscott1547/ssm-patchmanager/aws"
  version        = "0.1.0"
  os             = each.key
  is_default     = each.value.is_default
  approval_rules = each.value.approval_rules
}