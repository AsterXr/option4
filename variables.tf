variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR to be used"
  default     = "10.2.0.0/24"
}

variable "mgmt_cidr" {
  type        = string
  description = "Put your public ip here"
  default     = "x.x.x.x/32"
}

variable "debug" {
  type        = bool
  description = "Set this to true to add public IPs to the instances and open port 22 to mgmt_cidr for debugging reasons"
  default     = false
}
