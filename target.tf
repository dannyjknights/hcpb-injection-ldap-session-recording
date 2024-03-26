resource "boundary_target" "aws" {
  type                     = "ssh"
  name                     = "aws-ec2"
  description              = "AWS EC2 Targets"
  egress_worker_filter     = " \"sm-ingress-upstream-worker1\" in \"/tags/type\" "
  scope_id                 = boundary_scope.project.id
  session_connection_limit = -1
  default_port             = 22
  default_client_port      = 50505
  host_source_ids = [
    boundary_host_set_plugin.aws-db.id,
    boundary_host_set_plugin.aws-dev.id,
    boundary_host_set_plugin.aws-prod.id,
  ]
  enable_session_recording                   = true
  storage_bucket_id                          = boundary_storage_bucket.boundary_aws_bucket.id
  injected_application_credential_source_ids = [boundary_credential_library_vault_ssh_certificate.vault_ssh_cert.id]
  depends_on                                 = [boundary_storage_bucket.boundary_aws_bucket]
}