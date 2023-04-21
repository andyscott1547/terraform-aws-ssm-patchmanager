locals {
  patch_times = {
    Morning   = 05
    Afternoon = 13
    Evening   = 20
    Night     = 02
  }

  selected = local.patch_times[var.patch_window]
}