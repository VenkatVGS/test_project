
provider "aws" {
  region = var.aws_region
}

# Local values for consistent naming
locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Create S3 buckets first
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

# Create VPC
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = "10.0.0.0/16"
}

# Create EKS Cluster
module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  private_subnet_ids = module.vpc.private_subnets
  cluster_version    = "1.28"
  cluster_name       = "idurar-erp-cluster"
  region             = var.aws_region
}

# Configure Kubernetes Provider
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name
    ]
  }
}

# Configure Helm Provider
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name
      ]
    }
  }
}

# Create KMS Keys
module "kms" {
  source = "./modules/kms"

  project_name = var.project_name
}

# Create RDS PostgreSQL
module "rds" {
  source = "./modules/rds"

  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnets
  allowed_security_groups = [module.eks.cluster_primary_security_group_id]
  database_username       = "idurar_admin"
  database_password       = var.database_password
  kms_key_arn             = module.kms.rds_kms_key_arn
}

# Create ElastiCache Redis
module "elasticache" {
  source = "./modules/elasticache"

  project_name            = var.project_name
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnets
  allowed_security_groups = [module.eks.cluster_primary_security_group_id]
  node_type               = "cache.t3.micro"
  num_cache_nodes         = 1
}


# ECR Repository for hello-world service
module "ecr" {
  source = "./modules/ecr"

  repository_name = "${var.project_name}-hello-world"
  # kms_key_arn     = module.kms.ecr_kms_key_arn  # If you have KMS module
  common_tags = local.common_tags

  # allowed_principal_arns = [
  #  module.eks.cluster_iam_role_arn,  # EKS cluster role
  #  module.eks.node_group_iam_role_arn, # EKS node group role
  #]
}
