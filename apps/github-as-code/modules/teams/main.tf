resource "github_team" "this" {
  name        = var.name
  description = var.description == "" ? null : var.description
  privacy     = var.privacy == "" ? "closed" : var.privacy

  parent_team_id = var.parent_team_id == "" ? null : var.parent_team_id
}

resource "github_team_members" "this" {
  team_id = github_team.this.id

  dynamic "members" {
    for_each = var.members
    content {
      username = members.value
      # organization_admins are allways maintainers
      role = contains(var.organization_admins, members.value) ? "maintainer" : "member"
    }
  }
}
