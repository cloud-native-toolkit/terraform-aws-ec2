module "vpcssh" {
  source = "github.com/cloud-native-toolkit/terraform-aws-ssh-key"

  private_key_file = var.private_key_file
  private_key      = var.private_key
  public_key_file  = var.public_key_file
  public_key       = var.public_key
  rsa_bits         = var.rsa_bits
  prefix_name      = var.prefix_name
  name             = var.name
  label            = var.label
  name_prefix      = var.name_prefix
  region           = var.region

}
