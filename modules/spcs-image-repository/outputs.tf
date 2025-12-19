output "image_repository_name" {
  description = "Name of the image repository created"
  value       = var.image_repository_name
}

output "granted_read_roles" {
  description = "Roles that received READ privilege on the image repository"
  value       = var.read_roles
}

output "granted_write_roles" {
  description = "Roles that received WRITE privilege on the image repository"
  value       = var.write_roles
}
