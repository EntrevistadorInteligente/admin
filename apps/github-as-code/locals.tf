# Settings files
locals {
  org_config_file = "${path.module}/${var.org_dir_relative}/organization.yml"
  org_config      = yamldecode(file(local.org_config_file))
  ## config for the organization
  organization_name   = local.org_config.name
  organization_admins = local.org_config.admins
  teams               = local.org_config.teams
  default_branch_name = local.org_config.default_branch_name
  labels = {
    "duplicate"   = { color = "cfd3d7", description = "This issue or pull request already exists" }
    "help wanted" = { color = "008672", description = "Extra attention is needed" }
    "question"    = { color = "d876e3", description = "Further information is requested" }
    # others
    "blocked"      = { color = "ff0000", description = "Blocked by another issue" }
    "dependencies" = { color = "006b75", description = "Dependency updates" }
  }
}
