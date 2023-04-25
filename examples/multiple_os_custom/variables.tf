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

variable "patch_windows" {
  type = object({
    days    = set(string)
    periods = set(string)
  })

  description = "foo"
  default     = null
}

variable "lambda_functions" {
  type = map(object({
    timeout = optional (string, 15)
  }))
}