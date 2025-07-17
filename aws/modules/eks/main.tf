resource "aws_eks_cluster" "eks" {
  name = var.cluster_name

  access_config {
    authentication_mode = var.authentication_mode
  }

  role_arn = var.cluster_role_arn
  version  = var.kubernetes_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }
  tags = merge({
    Name = var.cluster_name
  }, var.tags)
}



#################################
# Node Group
#################################
resource "aws_eks_node_group" "eks-cluster-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  tags = merge({
    Name = var.cluster_name
  }, var.tags)
}

