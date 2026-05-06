#############################################
# VPC MODULE
#############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "istio-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  #########################################
  # REQUIRED FOR EKS (CRITICAL FIX)
  #########################################

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    "kubernetes.io/cluster/istio-terraform-cluster" = "shared"
    Project = "Istio-Terraform"
  }
}

#############################################
# EKS MODULE
#############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
access_entries = {
  admin = {
    principal_arn = "arn:aws:iam::742820980479:user/devops-user"

    policy_associations = {
      admin = {
        policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        access_scope = {
          type = "cluster"
        }
      }
    }
  }
}
  #########################################
  # API ACCESS FIX (IMPORTANT)
  #########################################

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  #########################################
  # NETWORK
  #########################################

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  #########################################
  # NODE GROUP (FIXED CONFIG)
  #########################################

  eks_managed_node_groups = {
    default = {
      desired_size = 2
      max_size     = 3
      min_size     = 1

      instance_types = ["m7i-flex.large"]   # Free-tier compatible

      ami_type = "AL2_x86_64"         # FIX: prevents AMI issues
    }
  }

  #########################################
  # TAGS
  #########################################

  tags = {
    Project = "Istio-Terraform"
  }
}
