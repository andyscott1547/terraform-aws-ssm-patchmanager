# example/locals

locals {
  ssm_association = ["Scan", "Install"]
  patch_windows = { for window in setproduct(var.patch_windows["days"], var.patch_windows["periods"]) :
    lower("${window[0]}_${window[1]}") => {
      day    = window[0]
      period = window[1]
    }
  }
}