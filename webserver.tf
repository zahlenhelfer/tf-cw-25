resource "aws_instance" "web" {
  count                  = var.instance_count
  ami                    = "ami-0b2ac948e23c57071"
  instance_type          = "t3.micro"
  user_data              = file("install_webserver.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
  monitoring             = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }
  tags = {
    Name       = "Webserver-${count.index + 1}"
    Costcenter = "666"
    AutoOff    = "True"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow web inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "Web from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
