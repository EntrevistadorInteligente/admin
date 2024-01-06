module "admin" {
  source = "./modules/repository"

  repository_name = "admin"
  description     = "Global GitHub settings for all repositories."

  visibility = "public"
  topics     = ["github-configuration"]

  config = {
    archived               = false
    homepage               = ""
    auto_init              = false
    allow_auto_merge       = false
    allow_merge_commit     = true
    allow_rebase_merge     = true
    allow_squash_merge     = true
    allow_update_branch    = true
    delete_branch_on_merge = true
    has_issues             = true
    has_downloads          = false
    has_discussions        = false
    has_projects           = false
    has_wiki               = false
    security = {
      enableVulnerabilityAlerts    = true
      enableAutomatedSecurityFixes = true
    }
  }

  default_branch_name = local.default_branch_name

  team_access = {
    admins = {
      team_id     = local.admins_team_id
      permissions = "admin"
    }
  }

  reviewers_team_slugs = [local.admins_team_id]

  variables = {}
}
