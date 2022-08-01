output "launch_template_id" {
  value = aws_launch_configuration.launch_config.id
}

output "launch_template_name" {
  value = aws_launch_configuration.launch_config.name
}