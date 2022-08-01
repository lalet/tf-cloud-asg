variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_group_ids" {
  type = list(any)
}

variable "launch_config" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "load_balancers" {
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

variable "topic_arn" {
  type = string
}