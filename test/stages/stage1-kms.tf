module "kms" {
  source           = "github.com/cloud-native-toolkit/terraform-aws-kms"
  description      = "KMS Keys for Data Encryption"
  key_spec         = var.key_spec
  rotation_enabled = var.rotation_enabled
  enabled          = var.enabled
  alias            = var.alias
  kms_alias        = var.kms_alias
  policy_file      = "scripts/kms-policy/kms-policy.json"
}
