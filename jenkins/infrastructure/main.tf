module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "default"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Environment = "continuous-delivery"
  }
}

module "alb" {
  source  = "github.com/terraform-aws-modules/terraform-aws-alb"

  load_balancer_name        = "jenkins"
  http_tcp_listeners        = "${list(map("port", "80", "protocol", "HTTP"))}"
  http_tcp_listeners_count  = "1"
  logging_enabled           = false
  security_groups           = ["${module.alb-security-group.this_security_group_id}"]
  subnets                   = "${module.vpc.public_subnets}"
  vpc_id                    = "${module.vpc.vpc_id}"
  target_groups_count       = 1
  target_groups = [
    {
      "name"             = "http80"
      "backend_protocol" = "HTTP"
      "backend_port"     = 80
      "slow_start"       = 0
      "target_type"      = "ip"
    }
  ]
  
  tags = {
    Environment = "continuous-delivery"
  }
}

module "alb-security-group" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 3.0"

  name        = "jenkins-alb"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "jenkins" {
  name   = "jenkins"
  vpc_id = "${module.vpc.vpc_id}"

  tags = {
    Environment = "continuous-delivery"
  }
}

resource "aws_security_group_rule" "jenkins" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "TCP"
  source_security_group_id = "${module.alb-security-group.this_security_group_id}"
  security_group_id        = "${aws_security_group.jenkins.id}"
  description              = "Open port 8080 to ALB"
}

resource "aws_security_group_rule" "outbound-internet-access-jenkins" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.jenkins.id}"
}
