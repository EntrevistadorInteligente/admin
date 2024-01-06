# Settings files
locals {
  org_config_file = "${path.module}/${var.org_dir_relative}/organization.yml"
  org_config      = yamldecode(file(local.org_config_file))
  ## config for the organization
  organization_name   = local.org_config.name
  organization_admins = local.org_config.admins
  teams               = local.org_config.teams
  default_branch_name = local.org_config.default_branch_name
}
