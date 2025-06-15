output "instance_public_ip" {
  description = "Public IP from the module"
  value       = module.solar_sys_app.instance_public_ip
}

output "instance_public_dns" {
  description = "Public DNS from the module"
  value       = module.solar_sys_app.instance_public_dns
}

