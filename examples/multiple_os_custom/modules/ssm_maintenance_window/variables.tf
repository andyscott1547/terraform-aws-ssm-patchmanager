# examples/multiple_os_custom/modules/ssm_maintenance_window/variables.tf

variable "maint_window_duration" {
  type        = number
  description = "Maintenance window duration in hours"
  default     = 6
}

variable "maint_window_cutoff" {
  type        = number
  description = "Maintenance window cutoff in hours"
  default     = 1
}

variable "allow_unassociated_targets" {
  type        = bool
  description = "Allow unassociated targets"
  default     = true
}

variable "schedule_timezone" {
  type        = string
  description = "Schedule timezone"
  default     = "GB"
}

variable "output_location" {
  type = string
  description = "Output location"
  default     = null
}

variable "patch_day" {
  type        = string
  description = "Patch day"
  default     = "SUN"
}

variable "patch_window" {
  type        = string
  description = "Patch window for time of day"
  default     = null
}
  