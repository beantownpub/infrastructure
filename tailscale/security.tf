# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "aws_security_group" "tailscale" {
  name        = "tailscale-sg"
  description = "Allow tailscale relay vpc inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  # Allow egress to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Provisioner = "Terraform"
  }
}
