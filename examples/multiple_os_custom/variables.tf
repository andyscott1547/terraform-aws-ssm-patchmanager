# example/variables

variable "region" {
  type        = string
  description = "value for the region"
  default     = "eu-west-1"
}

variable "tags" {
  type        = map(string)
  description = "value for the tags"
  default     = {}
}

variable "standard_os_baselines" {
  type        = map(any)
  description = "configuration for patch baseline for each operating system"
}

variable "critical_os_baselines" {
  type        = map(any)
  description = "configuration for patch baseline for each operating system for urgent patch operations"
}

variable "wait_for_success_timeout_seconds" {
  type        = number
  description = "Wait for success timeout in seconds"
  default     = 3600
}

variable "output_location" {
  type = list(object({
    output_s3_bucket_name = string
  }))
  description = "Output location"
  default     = []
}

variable "scan_schedule_expression" {
  type        = string
  description = "Schedule expression"
  default     = "cron(15 23 ? * * *)"
}

variable "maintenance_windows" {
  type        = map(any)
  description = "Maintenance windows"
}

variable "days" {
  type        = list(string)
  description = "Days of week"
  default     = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
}

variable "windows" {
  type = list(string)
  description = "Windows of day"
}