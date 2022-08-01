
resource "aws_launch_configuration" "launch_config" {
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = var.security_group_ids
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = var.launch_config
  availability_zones   = var.aws_availability_zones
  min_size             = var.min_size
  max_size             = var.max_size
  load_balancers       = var.load_balancers
  health_check_type    = "ELB"
  tag {
    key                 = "asg"
    value               = format("terraform-asg-%s", var.env)
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "asg_increment_policy" {
  name                   = format("asg_increment_policy-%s", var.env)
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_autoscaling_policy" "asg_decrement_policy" {
  name                   = format("asg_decrement_policy-%s", var.env)
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.asg.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_high_load" {
  alarm_name          = format("cpu-alarm-high-load-%s", var.env)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_increment_policy.arn, var.topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm_low_load" {
  alarm_name          = format("cpu-alarm-low-load-%s", var.env)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions     = [aws_autoscaling_policy.asg_decrement_policy.arn, var.topic_arn]
}