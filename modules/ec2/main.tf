resource "aws_instance" "hello-world" {
  ami                    = var.ami
  vpc_security_group_ids = var.vpc_security_group_ids
  source_dest_check      = false
  instance_type          = var.instance_type
  tags = {
    Name = var.instance_name
  }
}