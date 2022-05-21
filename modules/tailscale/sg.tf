# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "aws_security_group" "tailscale" {
  name        = "tailscale-subnet-router"
  description = "Allow tailscale-subnet-router vpc inbound traffic"
  vpc_id      = var.vpc_id

  # Allow egress to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Provisioner = "Terraform"
    Name        = "tailscale-subnet-router"
    Role        = "vpn"
  }
}
