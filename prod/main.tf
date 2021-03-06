#        **      **      **          ********    *******        **      **      **  ********  ********
#       /**     ****    /**         **//////**  /**////**      ****    /**     /** /**/////  **//////
#       /**    **//**   /**        **      //   /**   /**     **//**   /**     /** /**      /**
#       /**   **  //**  /**       /**           /*******     **  //**  //**    **  /******* /*********
#       /**  ********** /**       /**    *****  /**///**    **********  //**  **   /**////  ////////**
#   **  /** /**//////** /**       //**  ////**  /**  //**  /**//////**   //****    /**             /**
#  //*****  /**     /** /********  //********   /**   //** /**     /**    //**     /******** ********
#   /////   //      //  ////////    ////////    //     //  //      //      //      //////// ////////
# 2022

data "aws_region" "current" {}
data "aws_acm_certificate" "issued" {
  domain   = var.dns_zone
  statuses = ["ISSUED"]
}
module "labels" {
  source = "../modules/labels"

  environment = "prod"
  tags        = local.tags
}

locals {
  cluster_name = "${local.env}-${local.region_code}-jalgraves"
  env          = module.labels.environment
  region_code  = module.labels.region_code
  subnet_tags = {
    "kubernetes.io/cluster/prod-use1-jalgraves" = "owned"
  }
  tags = {
    "Module"      = "terraform-aws-network",
    "Provisioner" = "Terraform"
  }
}

module "network" {
  source  = "app.terraform.io/beantown/network/aws"
  version = "0.1.5"

  allow_ssh_from_ip               = var.local_ip
  availability_zones              = var.availability_zones[data.aws_region.current.name]
  create_ssh_sg                   = true
  default_security_group_deny_all = false
  environment                     = local.env
  cidr_block                      = "10.0.0.0/16"
  internet_gateway_enabled        = true
  label_create_enabled            = true
  nat_gateway_enabled             = false
  nat_instance_enabled            = false
  private_subnets_additional_tags = local.subnet_tags
  public_subnets_additional_tags  = local.subnet_tags
  region_code                     = local.region_code
  tags                            = local.tags
}

module "security" {
  source = "../modules/security-group"

  cluster_name    = local.cluster_name
  env             = local.env
  local_public_ip = var.local_ip
  name            = module.labels.security_group.name
  region_code     = module.labels.region_code
  web_sg_name     = module.labels.web_security_group.name
  vpc_id          = module.network.vpc_id
  description     = "Security group for K8s API traffic created via Terraform"
}

module "ec2" {
  source = "../modules/ec2"

  cluster_name    = local.cluster_name
  control_name    = module.labels.ec2_control.name
  domain_name     = var.dns_zone
  env             = local.env
  k8s_token       = var.k8s_token
  public_key      = var.public_key
  region_code     = local.region_code
  subnets         = module.network.public_subnet_ids
  security_groups = [module.security.internal_cluster_traffic.id, module.security.local_machine_traffic.id]
  worker_name     = module.labels.ec2_worker.name
  depends_on = [
    module.iam
  ]
}


module "alb" {
  source = "../modules/alb"

  certificate_arn  = data.aws_acm_certificate.issued.arn
  control_plane_id = module.ec2.instance.id
  worker_id        = module.ec2.worker.id
  name             = module.labels.alb.name
  vpc_id           = module.network.vpc_id
  subnets          = module.network.public_subnet_ids
  security_groups  = [module.security.internal_cluster_traffic.id, module.security.web_traffic.id]
  description      = "ALB for Beantown Pub"
}

module "iam" {
  source = "../modules/iam"

  env         = module.labels.environment
  region_code = module.labels.region_code
}
