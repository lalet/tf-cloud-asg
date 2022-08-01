variable "ami" {
  description = "Base AMI to launch the instances"
  type        = string
  default     = "ami-0bf93727c047adcf1"
}

variable "key_name" {
  description = "Key name for SSHing into EC2"
  type        = string
  default     = "aws-gunicorn"
}

variable "environment_name" {
  type        = string
  description = "Name of environment"
  default     = "staging"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type    = string
  default = "hello-world"
}

variable "env" {
  type    = string
  default = "staging"
}

variable "vpc_security_group_ids" {
  type    = list(any)
  default = []
}

variable "sg_name" {
  type    = string
  default = "hello-world-sg"
}

variable "region" {
  type    = string
  default = "us-west-2"
}

variable "ssl_certificate_id" {
  type    = string
  default = "arn:aws:acm:us-west-2:306984394133:certificate/16c563ab-166e-4725-8b5f-fa775f50d9f3"
}

variable "topic_arn" {
  type    = string
  default = "arn:aws:sns:us-west-2:306984394133:cpu_asg_alarm:e21cbd79-b859-4474-bc0a-9ceff032572d"
}






