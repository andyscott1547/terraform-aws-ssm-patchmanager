# variables

variable "env" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "os" {
  type        = string
  description = "Operating system"
  default     = "REDHAT_ENTERPRISE_LINUX"
  validation {
    condition     = contains(["REDHAT_ENTERPRISE_LINUX", "CENTOS", "AMAZON_LINUX", "AMAZON_LINUX_2", "AMAZON_LINUX_2022", "WINDOWS"], var.os)
    error_message = "Invalid OS Type, options: \"REDHAT_ENTERPRISE_LINUX\", \"CENTOS\", \"AMAZON_LINUX\", \"AMAZON_LINUX_2\", \"AMAZON_LINUX_2022\", \"WINDOWS\"."
  }
}

variable "rejected_patches" {
  type        = list(string)
  description = "List of rejected patches"
  default     = null
}

variable "approved_patches" {
  type        = list(string)
  description = "List of approved patches"
  default     = null
}

variable "approve_after_days" {
  type        = number
  description = "Number of days to approve patches after"
  default     = 7
}

variable "compliance_level" {
  type        = string
  description = "Compliance level"
  default     = "CRITICAL"
  validation {
    condition     = contains(["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "UNSPECIFIED"], var.compliance_level)
    error_message = "Invalid compliance level, options: \"CRITICAL\", \"HIGH\", \"MEDIUM\", \"LOW\", \"INFORMATIONAL\", \"UNSPECIFIED\"."
  }
}

variable "enable_non_security" {
  type        = bool
  description = "Enable non-security patches"
  default     = true
}

variable "global_filters" {
  type = list(object({
    key    = string
    values = list(string)
  }))
  description = "Global filters"
  default     = []
}

variable "approval_rules" {
  type = list(object({
    approve_after_days  = number
    compliance_level    = string
    enable_non_security = bool
    patch_filters = list(object({
      key    = string
      values = list(string)
    }))
  }))
  description = "Patch filters"
  default = [
    { approve_after_days  = 7,
      compliance_level    = "HIGH",
      enable_non_security = true,
      patch_filters = [{
        key    = "CLASSIFICATION",
        values = ["*"]
    }] }
  ]
}

variable "is_default" {
  type        = bool
  description = "Set as default patch baseline"
  default     = true
}

variable "wait_for_success_timeout_seconds" {
  type        = number
  description = "Wait for success timeout in seconds"
  default     = 3600
}

variable "scan_schedule_expression" {
  type        = string
  description = "Schedule expression"
  default     = "cron(15 23 ? * * *)"
}

variable "install_schedule_expression" {
  type        = string
  description = "Schedule expression"
  default     = "cron(0 0 ? * THU#2 *)"
}

variable "output_location" {
  type = list(object({
    output_s3_bucket_name = string
  }))
  description = "Output location"
  default     = []
}

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