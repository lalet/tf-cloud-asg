variable "ami" {
  type = string
}


variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(any)
}

variable "region" {
  type = string
}

