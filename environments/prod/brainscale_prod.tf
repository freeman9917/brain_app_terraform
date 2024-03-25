provider "aws" {
  region     = "ap-south-1"
}


provider "helm" {
  kubernetes {
  config_path = "~/.kube/config"
    host                   = module.my_eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.my_eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.my_eks.cluster_name]
      command     = "aws"
    }
   }
}

#  terraform {
#   backend "s3" {
#     bucket         = "vahe-brainscale-bucket"
#     key            = "prod/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "vahe-lock-table"
#   }
# }


################################################################################
# VPC Module
################################################################################
module "vpc" {
  source = "../../modules/vpc"
  env_prefix = var.env_prefix
  cidr_block = var.cidr_block
  pub1_subnet = var.pub1_subnet
  pub2_subnet = var.pub2_subnet
  priv1_subnet = var.priv1_subnet
  priv2_subnet = var.priv2_subnet
  az1 = var.az1
  az2 = var.az2
}




################################################################################
# EKS Module
################################################################################
module "my_eks" {
  source = "../../modules/eks"
  vpc_id =  module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  env_prefix = var.env_prefix
}


###############################################################################
#Helm Module
###############################################################################
module "helm" {
  depends_on = [ module.my_eks ]
  source = "../../modules/helm"
  # cluster_endpoint = module.my_eks.cluster_endpoint
  # cluster_certificate_authority_data = module.my_eks.cluster_certificate_authority_data
  # cluster_name = module.my_eks.cluster_name
  app_path = "prod/applications"
}





