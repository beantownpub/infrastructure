#
# Jalgraves 2021
#

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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuC1J8mDiAPHPMfJGd6vuoe0gzwrH8bCtSWK3wQ0+pgFon6mhRTfbLj7BCxBsTSBpWQoL1y8PRRtz2LXGY6OLlgxozlsCn1OouJCLALRUJSG5ek7p3+VF8+JT/OVh85i4iuOoK2s3M10HH1RGj+llvaTFSx8swjFtFcjxjFb4qcU19ZAWqK1BXICp0AklmLXussmPuOAaW6aFF3KecBk+774KplS/+ZPt1ZAnFV4pAJlc+jXBuwmqjUTHIOa8a38AHS28k042kCl9xQDsLad9sok5bzD6KopKfsGrP0Cm6s6hGc3okxIxMLPL3g8V+ldvsTAtfOct6Kq/CNfW2bDeAVZ32RQa1U1TO462rLP5IpWhkUHXkZdX4Z7XqQ8xXrXxEO2X696jRS45uSCoz5J2A7koOj1gYknYLuAqug9Na1tSAmJ0pYpC9eNAT3fhYOEdmmTD2IVNa8BJint1A+z0XmMs5LCIhnK2Lqw5EAeS3BGPv7+tHFe7FNnwUBYk4UTnmtiukSsxsKZu1hHbCURidsoXluvTytUpSmgAy1urbjGjSg1nN65W12BQFeg2JSHSqI6QgbfpUFOQo9jxuHJxv3AWDppPGyrqs3ChDdwUKnhM18e6UKRmzXmoXZBUOABNFDtmr0bJHsIHpAdR4FWnZtbPDqONSNpfHbkXQRtZ1Iw== jalgraves@gmail.com"
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
    "Name"                                      = var.control_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
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
    "Name"                                      = var.worker_name
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
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
    cluster_name = var.cluster_name
    env          = var.env
    k8s_token    = var.k8s_token
    k8s_version  = var.k8s_version
  }
}

data "template_file" "join" {
  template = file("${path.module}/templates/worker_user_data.sh")

  vars = {
    k8s_token  = "kq5cf0.c74d4q4syeomk94e"
    control_ip = aws_instance.control.private_ip
  }
}

