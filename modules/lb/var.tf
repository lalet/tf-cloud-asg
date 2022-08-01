variable "security_group_ids" {
  type = list(any)
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "aws_availability_zones" {
  type = list(any)
}

variable "ssl_certificate_id" {
  type = string
}