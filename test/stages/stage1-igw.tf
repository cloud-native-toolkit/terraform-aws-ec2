module "igw" {
  source ="github.com/cloud-native-toolkit/terraform-aws-vpc-gateways"
  #    provision = var.provision && var.cloud_provider == "aws" ? true : false
  provision           = var.provision
  resource_group_name = var.resource_group_name
  name_prefix         = var.name_prefix
  vpc_name            = module.vpc.vpc_name
}
