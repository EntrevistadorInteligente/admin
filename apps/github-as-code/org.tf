# Teams

locals {
  # create a map of team names to team config
  teams_for_module = {
    for team, team_config in local.teams : team_config.name => team_config
  }
}

module "teams" {
  source = "./modules/teams"

  for_each = local.teams_for_module

  name                = each.value.name
  description         = each.value.description
  members             = each.value.members
  organization_admins = local.organization_admins
}

locals {
  teams_ids = {
    for team, team_config in local.teams : team_config.name => module.teams[team_config.name].id
  }
  admins_team_id = local.teams_ids["admins"]
}

# Users

locals {
  team_members = distinct(flatten([
    for team, team_config in local.teams : team_config.members
  ]))
}

resource "github_membership" "members" {
  for_each = toset(local.team_members)

  username = each.value
  role     = contains(local.organization_admins, each.value) ? "admin" : "member"
}
