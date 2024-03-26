output "auth-method-id" {
  value = boundary_auth_method_ldap.forumsys_ldap.id
}

output "role-id" {
  value = boundary_role.read_roles.id
}

output "managed-group-id" {
  value = boundary_managed_group_ldap.science_group
}