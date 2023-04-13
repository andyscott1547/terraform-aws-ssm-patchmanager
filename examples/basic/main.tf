# example/main

module "amazon_linux_2" {
  source  = "andyscott1547/ssm-patchmanager/aws"
  version = "0.1.0"
  os      = "AMAZON_LINUX_2"
}