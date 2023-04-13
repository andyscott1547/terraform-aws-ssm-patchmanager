# example/main

module "amazon_linux_2" {
  for_each   = toset(var.os_list)
  source     = "andyscott1547/ssm-patchmanager/aws"
  version    = "0.1.0"
  os         = each.value
  is_default = true
}