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
  branch     = var.config.default_branch
}

resource "github_issue_labels" "main" {
  repository  = github_repository.main.name

  dynamic "label" {
    for_each = var.labels

    content {
      name        = label.key
      color       = label.value.color
      description = try(label.value.description, "")
    }
  }
}

resource "github_team_repository" "main" {
  for_each = var.team_access

  repository = github_repository.main.name
  team_id    = each.value.team_id
  permission = each.value.permissions
}

# TODO: only for apps repos
resource "github_branch_protection" "main" {
  for_each = var.branches

  repository_id = github_repository.main.node_id

  pattern                         = each.key

  # TODO: required_signatures                  = each.value.protection.required_signatures
  enforce_admins                       = each.value.protection.enforce_admins
  required_linear_history              = each.value.protection.required_linear_history
  allows_force_pushes                   = each.value.protection.allow_force_pushes
  allows_deletions                      = each.value.protection.allow_deletions
  blocks_creations                      = each.value.protection.block_creations
  require_conversation_resolution     = each.value.protection.required_conversation_resolution
  lock_branch                          = each.value.protection.lock_branch
  # TODO: allow_fork_syncing                   = each.value.protection.allow_fork_syncing

  required_pull_request_reviews {
    dismiss_stale_reviews              = each.value.protection.required_pull_request_reviews.dismiss_stale_reviews
    require_code_owner_reviews         = each.value.protection.required_pull_request_reviews.require_code_owner_reviews
    require_last_push_approval         = each.value.protection.required_pull_request_reviews.require_last_push_approval
    required_approving_review_count    = each.value.protection.required_pull_request_reviews.required_approving_review_count
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

# TODO: Create branch if the branch does not exist before adding the branch protection
