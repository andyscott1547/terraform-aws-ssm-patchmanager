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