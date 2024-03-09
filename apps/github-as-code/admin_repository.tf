module "admin" {
  source = "./modules/admin_repository"

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
    has_issues             = false
    has_downloads          = false
    has_discussions        = false
    has_projects           = false
    has_wiki               = false
    security = {
      enableVulnerabilityAlerts    = true
      enableAutomatedSecurityFixes = true
    }
  }

  default_branch_name = "main"

  default_branch_protection = {
    enforce_admins                  = false
    allows_deletions                = false
    require_conversation_resolution = true

    required_pull_request_reviews = {
      dismiss_stale_reviews      = true
      require_code_owner_reviews = true
      restrict_dismissals        = false
    }
  }

  team_access = {
    admins = {
      team_id     = local.admins_team_id
      permissions = "admin"
    }
  }

  labels = {
    "duplicate"   = { color = "cfd3d7", description = "This issue or pull request already exists" }
    "help wanted" = { color = "008672", description = "Extra attention is needed" }
    "question"    = { color = "d876e3", description = "Further information is requested" }
    # others
    "blocked"      = { color = "ff0000", description = "Blocked by another issue" }
    "dependencies" = { color = "006b75", description = "Dependency updates" }
  }

  variables = {}
}
