#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

data "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnet" "main" {
  id = var.subnet_id
}

data "aws_security_group" "main" {
  id = var.security_group_id
}

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

data "template_file" "init" {
  template = file("${path.cwd}/relay-init.sh.tpl")

  vars = {
    subnets_to_advertise = "10.0.96.0/20,10.0.112.0/20"
    tailscale_auth_key   = tailscale_tailnet_key.ec2_relay.key
  }
  depends_on = [
    tailscale_tailnet_key.ec2_relay
  ]
}

resource "aws_key_pair" "tailscale" {
  key_name   = "tailscale-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "tailscale-relay" {
  ami           = var.ami == null ? data.aws_ami.amazon_linux2.id : var.ami
  instance_type = "t3.nano"

  # Refer to the security group we just created
  vpc_security_group_ids = [aws_security_group.tailscale.id, data.aws_security_group.main.id]
  subnet_id              = data.aws_subnet.main.id

  user_data = data.template_file.init.rendered

  depends_on = [
    tailscale_tailnet_key.ec2_relay
  ]

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    encrypted   = false
    volume_size = 8
  }

  key_name = aws_key_pair.tailscale.key_name

  tags = {
    Provisioner = "Terraform"
    Name        = "tailscale-relay"
  }
}
