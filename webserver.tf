resource "aws_instance" "web" {
  ami                    = "ami-0b2ac948e23c57071"
  instance_type          = "t3.micro"
  user_data              = file("install_webserver.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  subnet_id              = module.vpc.public_subnets[0]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }
  tags = {
    Name       = "HelloWorld"
    Costcenter = "666"
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
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
