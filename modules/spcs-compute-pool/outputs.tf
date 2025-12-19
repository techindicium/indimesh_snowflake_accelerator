output "compute_pool_name" {
  description = "Name of the compute pool created"
  value       = var.compute_pool_name
}

output "granted_usage_roles" {
  description = "Roles that received USAGE privilege on the compute pool"
  value       = var.usage_roles
}

output "granted_all_privileges_roles" {
  description = "Roles that received ALL PRIVILEGES on the compute pool"
  value       = var.all_privileges_roles
}