locals {
  branches = [
    var.default_branch_name,
    "develop"
  ]
}

resource "github_repository" "main" {
  name                        = var.repository_name
  description                 = var.description
  visibility                  = var.visibility
  archived                    = var.config.archived
  archive_on_destroy          = true
  homepage_url                = var.config.homepage
  topics                      = var.topics
  auto_init                   = var.config.auto_init
  allow_auto_merge            = var.config.allow_auto_merge
  allow_merge_commit          = var.config.allow_merge_commit
  allow_rebase_merge          = var.config.allow_rebase_merge
  allow_squash_merge          = var.config.allow_squash_merge
  allow_update_branch         = var.config.allow_update_branch
  delete_branch_on_merge      = var.config.delete_branch_on_merge
  has_issues                  = var.config.has_issues
  has_downloads               = var.config.has_downloads
  has_discussions             = var.config.has_discussions
  has_projects                = var.config.has_projects
  has_wiki                    = var.config.has_wiki
  merge_commit_title          = "MERGE_MESSAGE"
  merge_commit_message        = "PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  vulnerability_alerts        = var.config.security.enableVulnerabilityAlerts
}

resource "github_branch_default" "main" {
  repository = github_repository.main.name
  branch     = var.default_branch_name
}

resource "github_issue_label" "main" {
  for_each = var.labels

  repository  = github_repository.main.name
  name        = each.key
  color       = each.value.color
  description = try(each.value.description, "")
}

resource "github_team_repository" "main" {
  for_each = var.team_access

  repository = github_repository.main.name
  team_id    = each.value.team_id
  permission = each.value.permissions
}

# TODO: pnly for apps repos
resource "github_branch_protection" "banch_protection" {
  for_each = toset(local.branches)

  repository_id = github_repository.main.node_id

  pattern                         = each.value
  enforce_admins                  = var.default_branch_protection.enforce_admins
  allows_deletions                = var.default_branch_protection.allows_deletions
  require_conversation_resolution = var.default_branch_protection.require_conversation_resolution

  required_pull_request_reviews {
    dismiss_stale_reviews      = var.default_branch_protection.required_pull_request_reviews.dismiss_stale_reviews
    require_code_owner_reviews = var.default_branch_protection.required_pull_request_reviews.require_code_owner_reviews
    restrict_dismissals        = var.default_branch_protection.required_pull_request_reviews.restrict_dismissals
  }
}

resource "github_actions_variable" "main" {
  for_each = var.variables

  repository    = github_repository.main.name
  variable_name = each.key
  value         = each.value
}

resource "github_repository_dependabot_security_updates" "main" {
  repository = github_repository.main.name
  enabled    = var.config.security.enableAutomatedSecurityFixes
}
