
data "aws_availability_zones" "all" {}

module "ec2-instance" {
  source                 = "../modules/ec2"
  ami                    = var.ami
  region                 = local.region
  instance_type          = var.instance_type
  instance_name          = format("%s-%s", var.instance_name, var.env)
  vpc_security_group_ids = [module.sg.security_group_id]
}

module "sg" {
  source  = "../modules/sg"
  sg_name = var.sg_name
  env     = var.env
  region  = local.region
}

module "lb" {
  source                 = "../modules/lb"
  security_group_ids     = [module.sg.security_group_id]
  env                    = var.env
  region                 = local.region
  aws_availability_zones = data.aws_availability_zones.all.names
  ssl_certificate_id     = var.ssl_certificate_id
}

module "asg" {
  source                 = "../modules/asg"
  image_id               = var.ami
  env                    = var.env
  instance_type          = var.instance_type
  security_group_ids     = [module.sg.security_group_id]
  launch_config          = module.asg.launch_template_id
  min_size               = 2
  max_size               = 10
  load_balancers         = [module.lb.elb_name]
  region                 = local.region
  aws_availability_zones = data.aws_availability_zones.all.names
  topic_arn              = var.topic_arn
}
