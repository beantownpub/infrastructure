# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_key_pair" "control" {
  key_name   = "${var.env}-${var.region_code}-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "control" {
  ami                         = var.ami == null ? data.aws_ami.amazon_linux2.id : var.ami
  instance_type               = "t3.medium"
  user_data                   = data.template_file.init.rendered
  vpc_security_group_ids      = var.security_groups
  iam_instance_profile        = "K8sControlPlane"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.control.key_name
  subnet_id                   = var.subnets[0]
  tags = {
    "Name"                                        = var.control_name
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  root_block_device {
    encrypted   = false
    volume_size = 25
  }
}

resource "aws_instance" "worker" {
  ami                         = var.ami == null ? data.aws_ami.amazon_linux2.id : var.ami
  instance_type               = "t3.medium"
  user_data                   = data.template_file.join.rendered
  vpc_security_group_ids      = var.security_groups
  iam_instance_profile        = "K8sWorker"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.control.key_name
  subnet_id                   = var.subnets[1]
  tags = {
    "Name"                                        = var.worker_name
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }

  root_block_device {
    encrypted   = false
    volume_size = 25
  }
  depends_on = [
    aws_instance.control
  ]
}

data "template_file" "init" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    cilium_version = local.app_versions.cilium
    cluster_name   = local.cluster_name
    domain_name    = var.domain_name
    env            = var.env
    istio_version  = local.app_versions.istio
    k8s_token      = var.k8s_token
    k8s_version    = local.app_versions.k8s
  }
}

data "template_file" "join" {
  template = file("${path.module}/templates/worker_user_data.sh")

  vars = {
    k8s_token  = var.k8s_token
    control_ip = aws_instance.control.private_ip
  }
}
