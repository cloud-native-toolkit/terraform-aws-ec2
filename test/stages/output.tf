output "vpc_id" {
  depends_on = [module.vpc]
  value      = module.vpc.vpc_id
}
