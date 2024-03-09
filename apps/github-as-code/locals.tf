# Settings files
locals {
  org_config_file = "${path.module}/${var.org_dir_relative}/organization.yml"
  org_config      = yamldecode(file(local.org_config_file))
  ## config for the organization
  organization_name   = local.org_config.name
  organization_admins = local.org_config.admins
  teams               = local.org_config.teams
  # config for the repositories and common settings
  repo_common_config_file   = "${path.module}/${var.org_dir_relative}/settings.yml"
  repo_common_config        = yamldecode(file(local.repo_common_config_file))
  repository_dir            = "${path.module}/${var.repository_dir_relative}"
  repository_file_extension = ".yml"
  repository_files          = fileset(local.repository_dir, "*${local.repository_file_extension}")
  repository_names          = toset([for file in local.repository_files : trimsuffix(basename(file), local.repository_file_extension)])
  repository_config         = { for name in local.repository_names : name => yamldecode(file("${local.repository_dir}/${name}${local.repository_file_extension}")) }
}
