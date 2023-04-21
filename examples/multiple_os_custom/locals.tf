# example/locals

locals {
  ssm_association = ["Scan", "Install"]
  result = setproduct(var.days, var.windows)
  result_map = for pair in local.result : {"${pair[0]}-${pair[1]}"
  }
}