############################
# VPC MODULE
############################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  ############################
  # REQUIRED TAGS FOR EKS
  ############################
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    "kubernetes.io/cluster/devops-eks-cluster" = "shared"
  }
}

############################
# EKS MODULE
############################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "devops-eks-cluster"
  cluster_version = "1.28"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  ############################
  # NETWORK ACCESS FIX
  ############################
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  ############################
  # IAM ACCESS (IMPORTANT)
  ############################
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

  ############################
  # NODE GROUP (FREE-TIER SAFE)
  ############################
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.small"]
      ami_type       = "AL2_x86_64"

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }
}
