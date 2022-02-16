module "ec2" {
  source         = "./module"
  vpc_id         = module.vpc.vpc_id
  subnet_ids_pri = module.subnets.private_subnet_ids
  subnet_ids_pub = module.subnets.public_subnet_ids
  #  subnet_ids_pri       = var.subnet_ids_pri
  #  subnet_ids_pub       = var.subnet_ids_pub
  #  subnet_count_private = 1
  #  subnet_count_public  = 1
  ami_id                      = var.ami_id
  subnet_count_private        = module.subnets.subnet_count_private
  subnet_count_public         = module.subnets.subnet_count_public
  instance_type               = var.instance_type
  publickey                   = var.publickey
  root_block_device_encrypted = var.root_block_device_encrypted
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  publicIP                    = var.publicIP
  ssh_key                     = module.vpcssh.swesshkeyname
  kms_key_id                  = module.kms.key_arn
}

