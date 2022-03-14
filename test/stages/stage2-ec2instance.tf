module "ec2" {
  source                      = "./module"
  vpc_id                      = module.vpc.vpc_id
  subnet_ids_pri              = module.priv_subnet.subnet_ids
  subnet_ids_pub              = module.pub_subnet.subnet_ids
  ami_id                      = var.ami_id
  subnet_count_private        = module.priv_subnet.subnet_count
  subnet_count_public         = module.pub_subnet.subnet_count
  instance_type               = var.instance_type
  publickey                   = var.publickey
  root_block_device_encrypted = var.root_block_device_encrypted
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
  publicIP                    = var.publicIP
  ssh_key                     = module.vpcssh.swesshkeyname
  kms_key_id                  = module.kms.key_arn

}

