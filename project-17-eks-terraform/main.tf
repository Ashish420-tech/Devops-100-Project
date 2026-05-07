module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  cluster_name = var.cluster_name
  azs          = var.azs
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}
