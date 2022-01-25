module "ec2_inst_mod" {
  source = "./module"
  #  depends_on                  = [module.dev_vpc_subnet]
  vpc_id                      = module.dev_vpc.vpc_id
  subnet_ids_pri              = module.dev_vpc_subnet.private_subnet_ids
  subnet_ids_pub              = module.dev_vpc_subnet.public_subnet_ids
  ami_id                      = var.ami_id
  subnet_count_private        = module.dev_vpc_subnet.subnet_count_private
  subnet_count_public         = module.dev_vpc_subnet.subnet_count_public
  instance_type               = var.instance_type
  publickey                   = var.publickey
  root_block_device_encrypted = var.root_block_device_encrypted
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
}

