#
# Jalgraves 2021
#

resource "aws_security_group" "internal_cluster_traffic" {
  name        = var.name
  description = "Allow K8s TLS inbound traffic from within VPC"
  vpc_id      = var.vpc_id

  ingress {
    description = "K8s API from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                                        = var.name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "web_traffic" {
  name        = var.web_sg_name
  description = "Allow inbound web traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Web HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Web HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name                                        = var.web_sg_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group" "local_machine_traffic" {
  count       = var.local_public_ip != null ? 1 : 0
  name        = "${var.env}-${var.region_code}-local-machine-access"
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.public_ipv4
  }

  ingress {
    description = "Allow K8s API access from my IP"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = local.public_ipv4
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                        = "${var.env}-${var.region_code}-local-machine-access"
    "kubernetes.io/cluster/${var.cluster_name}" = "member"
  }
}
