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