module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "3.7.0"
  name               = "my-vpc"
  cidr               = "10.0.0.0/16"
  azs                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets   = ["10.0.111.0/24", "10.0.112.0/24", "10.0.113.0/24"]
  enable_vpn_gateway = false
}
