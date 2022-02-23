output "vpc_id" {
  depends_on = [module.vpc]
  value      = module.vpc.vpc_id
}

output "default_network_acl_id" {
  depends_on = [module.vpc]
  value      = module.vpc.default_network_acl_id
  #value  = ""
  description = "The id for the default network acl"
}

output "instance_public_ip" {
  value       = ["${module.ec2.instance_public_ip}"]
  description = "The public IP address of the instance."
}

