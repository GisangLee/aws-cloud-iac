module "vpc" {
    source = "../../modules/vpc"
    vpc_name = "dev-vpc"
    cidr_block = "10.0.0.0/16"
    public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
    tags = {
        Environment = "dev"
        Owner       = "devops"
    }
}


module "lb" {
    source = "../../modules/lb"
    lb_name = "dev-lb"
    lb_type = "application"
    subnet_ids           = module.vpc.public_subnet_ids
    security_group_ids   = [aws_security_group.alb.id]
    tags = {
        Environment = "dev"
        Owner       = "devops"
    }
}
module "nacl" {
  source = "../../modules/nacl"
  vpc_id                  = module.vpc.vpc_id
  nacl_name = "nacl"
  public_subnet_id = module.vpc.public_subnet_ids[0]
  public_nacl_ingress_rules = local.public_nacl_ingress_rules
  public_nacl_egress_rules  = local.public_nacl_egress_rules  
  tags = {
    Environment = "dev"
    Owner       = "devops"
  }
}


module "eks" {
  source = "../../modules/eks"

  cluster_name        = "dev-eks"
  kubernetes_version  = "1.31"
  authentication_mode = "API"
  subnet_ids          = module.vpc.private_subnet_ids
  cluster_role_arn    = aws_iam_role.cluster.arn
  node_role_arn       = aws_iam_role.eks-node-group-iam-role.arn

  node_desired_size   = 2
  node_min_size       = 1
  node_max_size       = 3
  node_group_name     = "eks-node-group"
  instance_types      = ["t3.medium"]
  # ✅ 의존성 명시: cluster IAM이 먼저 생성돼야 module.eks 실행
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-group-AmazonEC2ContainerRegistryReadOnly
  ]

  tags = {
    Environment = "dev"
    Owner       = "devops"
  }
}

#########################################
# LB 전용 SG
#########################################
resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Allow inbound HTTP traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
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
    Name        = "alb-sg"
    Environment = "dev"
  }
}


