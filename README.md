#AWS EC2 Instance Terraform module

Provision EC2 Instances in AWS

- Attach Public/Private IP based on Subnet Zone
- Attach SSH Keys
- Enable Monitoring
- Allow users to run custom scripts


## Module overview

This is a AWS EC2 instance Terraform  module help users to provision and configure EC2 insatnces on AWS Cloud

Description of module

**Note:** This module follows the Terraform conventions regarding how provider configuration is defined within the Terraform template and passed into the module - https://www.terraform.io/docs/language/modules/develop/providers.html. The default provider configuration flows through to the module. If different configuration is required for a module, it can be explicitly passed in the `providers` block of the module - https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly.

### Software dependencies

The module depends on the following software components:

#### Command-line tools

- terraform >= v0.15

#### Terraform providers

- IBM Cloud provider >= 1.5.3

### Module dependencies

This module makes use of the output from other modules:

- Subnet  - github.com/cloud-native-toolkit/terraform-aws-vpc-subnets
- SSH  - github.com/cloud-native-toolkit/

### Example usage

```hcl-terraform

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

module "dev_vpc" {
  source    = "github.com/cloud-native-toolkit/terraform-aws-vpc"
  vpc_id           = var.vpc_id

}


module "dev_vpc_subnet" {
  source                          = "github.com/cloud-native-toolkit/terraform-aws-vpc-subnets"
  vpc_id                          = module.dev_vpc.vpc_id
  private_subnet_cidr             = var.private_subnet_cidr
  public_subnet_cidr              = var.public_subnet_cidr
  availability_zones              = var.availability_zones
  map_customer_owned_ip_on_launch = false
  map_public_ip_on_launch         = false
  tags                            = var.tags
  public_subnet_tags              = var.public_subnet_tags
  private_subnet_tags             = var.private_subnet_tags

}

module "ec2_inst_mod" {
  source = "./module"
  vpc_id = module.dev_vpc.vpc_id
  subnet_ids_pri              = module.dev_vpc_subnet.private_subnet_ids
  subnet_ids_pub              = module.dev_vpc_subnet.public_subnet_ids
  ami_id               = var.ami_id
  subnet_count_private        = module.dev_vpc_subnet.subnet_count_private
  subnet_count_public         = module.dev_vpc_subnet.subnet_count_public
  instance_type               = var.instance_type
  publickey                   = var.publickey
  root_block_device_encrypted = var.root_block_device_encrypted
  root_volume_size            = var.root_volume_size
  root_volume_type            = var.root_volume_type
}


```
