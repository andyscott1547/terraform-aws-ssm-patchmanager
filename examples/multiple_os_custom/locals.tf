# example/locals

locals {
  ssm_association = ["Scan", "Install"]
  results = { for pair in setproduct(var.days, var.windows) : pair[0] => pair[1]...}
  result = setproduct(var.days, var.windows)
  test = [
    for item in local.result : merge({day = item[0]}, {window = item[1]})
  ]
}