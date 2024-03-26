resource "boundary_auth_method_ldap" "forumsys_ldap" {
  name                 = "LDAP Test Auth"
  description          = "LDAP auth method for test server"
  scope_id             = boundary_scope.global.id
  urls                 = ["ldap://ldap.forumsys.com"]
  user_dn              = "dc=example,dc=com"
  user_attr            = "uid"
  group_dn             = "dc=example,dc=com"
  bind_dn              = "cn=read-only-admin,dc=example,dc=com"
  bind_password        = "password"
  state                = "active-public"
  enable_groups        = true
  is_primary_for_scope = true


}

resource "boundary_account_ldap" "ldap_user" {
  auth_method_id = boundary_auth_method_ldap.forumsys_ldap.id
  login_name     = "user1"
  name           = "user1"
  description    = "LDAP account for user1"
}

resource "boundary_managed_group_ldap" "science_group" {
  auth_method_id = boundary_auth_method_ldap.forumsys_ldap.id
  name           = "science-group"
  group_names    = ["Scientists"]

}

resource "boundary_role" "read_roles" {
  name          = "read-roles"
  description   = "List and read roles"
  principal_ids = [boundary_managed_group_ldap.science_group.id]
  //grant_strings = ["ids=*;type=role;actions=list,read", "ids=*;type=scope;actions=list,read"]
  grant_strings = ["ids=*;type=*;actions=*", "ids=*;type=scope;actions=*"]
  scope_id      = "global"
}


resource "boundary_role" "ldap_user_role_project" {
  name          = "LDAP User Role"
  description   = "ldap user role project"
  principal_ids = [boundary_managed_group_ldap.science_group.id]
  grant_strings = ["ids=*;type=*;actions=*"]
  scope_id      = boundary_scope.project.id
}