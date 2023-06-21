resource "aws_instance" "windows-web-server" {
  ami                    = "ami-00b95ae25143f8b10"
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  user_data              = file("install-iis.ps1")
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.allow_http_windows.id]
  key_name               = "demo-key"

  tags = {
    Name       = "IIS ${count.index + 1}"
    CostCenter = "4711"
  }

  count = 1

}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-windows-web-server" {
  count                     = 1
  alarm_name                = "alarm-ec2-cpu-${aws_instance.windows-web-server[count.index].id}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  period                    = 120
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  statistic                 = "Average"
  threshold                 = 80
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  dimensions = {
    InstanceId = aws_instance.windows-web-server[count.index].id
  }
}

resource "aws_security_group" "allow_http_windows" {
  name        = "allow_http_windows"
  description = "Allow web inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http Anfragen vom Inet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "rdp Anfragen vom Inet"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http_windows"
  }
}
