resource "aws_instance" "web" {
  ami             = "ami-0b2ac948e23c57071"
  instance_type   = "t3.micro"
  user_data       = file("install_webserver.sh")
  security_groups = [aws_security_group.allow_http.name]
  tags = {
    Name       = "HelloWorld"
    Costcenter = "666"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow web inbound traffic"

  ingress {
    description = "TLS from VPC"
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
