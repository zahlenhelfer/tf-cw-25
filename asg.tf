resource "aws_launch_configuration" "launch_config" {
  name_prefix     = "terraform-example-web-instance"
  image_id        = "ami-04c921614424b07cd"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.allow_http.id]
  user_data       = file("install_webserver.sh")
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "autoscaling_group" {
  launch_configuration = aws_launch_configuration.launch_config.id
  min_size             = 2
  max_size             = 5
  target_group_arns    = [aws_alb_target_group.web-group.arn]
  vpc_zone_identifier  = [module.vpc.private_subnets.0, module.vpc.private_subnets.1, module.vpc.private_subnets.2]

  tag {
    key                 = "Name"
    value               = "terraform-example-autoscaling-group"
    propagate_at_launch = true
  }

  depends_on = [
    module.vpc
  ]
}
