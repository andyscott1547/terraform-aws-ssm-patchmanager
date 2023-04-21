locals {
  patch_window = var.patch_window == "Morning" ? 05 : local.not_morning
  not_morning =  var.patch_window == "Afternoon" ? 13 : local.not_afternoon
  not_afternoon = var.patch_window == "Evening" ? 20 : 02
}