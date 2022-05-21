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
    name = "name"
    # values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    values = ["amzn2-ami-kernel-*-*-gp2"]
  }
}

data "template_file" "init" {
  template = file("${path.module}/relay-init.sh.tpl")

  vars = {
    subnets_to_advertise = var.subnets_to_advertise
    tailscale_auth_key   = var.tailscale_auth_key
  }
}

resource "aws_key_pair" "tailscale" {
  key_name   = "tailscale-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "tailscale_subnet_router" {
  ami                    = var.ami == null ? data.aws_ami.amazon_linux2.id : var.ami
  instance_type          = "t3.nano"
  key_name               = aws_key_pair.tailscale.key_name
  vpc_security_group_ids = concat([aws_security_group.tailscale.id], var.security_group_ids)
  subnet_id              = var.subnets[0]
  user_data              = data.template_file.init.rendered
  tags = {
    Provisioner = "Terraform"
    Name        = "tailscale-subnet-router"
    RegionCode  = var.region_code
    Role        = "vpn"
  }
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    encrypted   = false
    volume_size = 8
    volume_type = "gp3"
  }
}
