module "vpc" {
  source    = "github.com/cloud-native-toolkit/terraform-aws-vpc"
  provision = var.provision

  /* Input params required to provision new VPC */

#  internal_cidr    = var.internal_cidr
  internal_cidr    = "10.20.0.0/16"
  instance_tenancy = var.instance_tenancy
  name_prefix      = var.name_prefix
}
