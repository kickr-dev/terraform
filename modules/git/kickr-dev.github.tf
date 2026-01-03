resource "github_organization_settings" "kickr-dev" {
  name        = "Kickr"
  blog        = "https://kickr.dev"
  description = "Kickr organization. Implement your own project kickstarter or use our own CLI."
  email       = data.sops_file.sops["github"].data["support_email"]

  billing_email = data.sops_file.sops["github"].data["billing_email"]
  location      = "France"

  default_repository_permission = "write"
  web_commit_signoff_required   = true

  advanced_security_enabled_for_new_repositories               = false # cannot be true it seems
  dependabot_alerts_enabled_for_new_repositories               = true
  dependabot_security_updates_enabled_for_new_repositories     = true
  dependency_graph_enabled_for_new_repositories                = true
  secret_scanning_enabled_for_new_repositories                 = true
  secret_scanning_push_protection_enabled_for_new_repositories = true

  members_can_create_pages        = true
  members_can_create_repositories = true

  members_can_create_private_pages        = false
  members_can_create_private_repositories = false
  members_can_fork_private_repositories   = false

  members_can_create_public_pages        = true
  members_can_create_public_repositories = true

  has_organization_projects = false
  has_repository_projects   = false
}
