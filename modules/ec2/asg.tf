# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# |*|*|*|*| |J|A|L|G|R|A|V|E|S| |*|*|*|*|
# +-+-+-+-+ +-+-+-+-+-+-+-+-+-+ +-+-+-+-+
# 2022

resource "aws_launch_configuration" "worker" {
  name_prefix          = "worker-"
  image_id             = var.ami == null ? data.aws_ami.amazon_linux2.id : var.ami
  instance_type        = "t3.medium"
  security_groups      = var.security_groups
  iam_instance_profile = "K8sWorker"
  user_data            = data.template_file.join.rendered
  key_name             = aws_key_pair.control.key_name
  lifecycle {
    create_before_destroy = true
  }
  root_block_device {
    encrypted   = false
    volume_size = 25
  }
}

resource "aws_autoscaling_group" "workers" {
  name                 = "workers"
  launch_configuration = aws_launch_configuration.worker.name
  min_size             = 1
  max_size             = 2
  target_group_arns    = var.target_group_arns
  termination_policies = ["OldestInstance"]
  vpc_zone_identifier  = var.subnets

  lifecycle {
    create_before_destroy = true
  }
}
