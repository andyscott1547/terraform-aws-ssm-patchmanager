# example/main

module "amazon_linux_2" {
  for_each       = var.operating_systems
  source         = "github.com/andyscott1547/terraform-aws-ssm-patchmanager"
  os             = each.key
  is_default     = each.value.is_default
  approval_rules = each.value.approval_rules
}