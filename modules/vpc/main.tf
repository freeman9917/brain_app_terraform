module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  name = "my-${var.env_prefix}-vpc"
  cidr = var.cidr_block

  azs      = [var.az1, var.az2]
  public_subnets      = [var.pub1_subnet, var.pub2_subnet]
  private_subnets = [var.priv1_subnet, var.priv2_subnet]

  create_igw = true
  map_public_ip_on_launch = true
  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnet_tags = {    
    "kubernetes.io/role/elb" = 1
    "kubernetes.io/cluster/${var.env_prefix}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.env_prefix}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  } 
}
