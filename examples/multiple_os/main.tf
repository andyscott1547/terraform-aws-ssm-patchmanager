# example/main

module "amazon_linux_2" {
  for_each   = toset(var.os_list)
  source     = "github.com/andyscott1547/terraform-aws-ssm-patchmanager"
  os         = each.value
  is_default = true
}