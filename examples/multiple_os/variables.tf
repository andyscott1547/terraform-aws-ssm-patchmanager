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

variable "os_list" {
  type        = list(string)
  description = "List of OS to build"
  default     = ["AMAZON_LINUX_2", "REDHAT_ENTERPRISE_LINUX", "AMAZON_LINUX_2022"]
}