locals {
  org_config_tf = {
    teams = try({
      for team in local.repo_common_config.teams : team.name => team.permission
    }, {})
    labels = try({
      for label in local.repo_common_config.labels : label.name => {
        description = label.description
        color       = label.color
      }
    }, {})
    variables = try({
      for variable in local.repo_common_config.variables : variable.name => variable.value
    }, {})
    branches = try({
      for branch in local.repo_common_config.branches : branch.name => {
        protection = {
          required_signatures              = try(branch.protection.required_signatures, false)
          enforce_admins                   = try(branch.protection.enforce_admins, false)
          required_linear_history          = try(branch.protection.required_linear_history, true)
          allow_force_pushes               = try(branch.protection.allow_force_pushes, false)
          allow_deletions                  = try(branch.protection.allow_deletions, false)
          block_creations                  = try(branch.protection.block_creations, false)
          required_conversation_resolution = try(branch.protection.required_conversation_resolution, true)
          lock_branch                      = try(branch.protection.lock_branch, false)
          allow_fork_syncing               = try(branch.protection.allow_fork_syncing, false)
          required_pull_request_reviews = {
            dismiss_stale_reviews           = try(branch.protection.dismiss_stale_reviews, true)
            require_code_owner_reviews      = try(branch.protection.require_code_owner_reviews, true)
            require_last_push_approval      = try(branch.protection.require_last_push_approval, true)
            required_approving_review_count = try(branch.protection.required_approving_review_count, 1)
          }
        }
      }
    }, {})
  }

  repo_config = {
    for name, config in local.repository_config : name => {
      teams = try({
        for team in config.teams : team.name => team.permission
      }, {})
      labels = try({
        for label in config.labels : label.name => {
          description = label.description
          color       = label.color
        }
      }, {})
      variables = try({
        for variable in config.variables : variable.name => variable.value
      }, {})
      branches = try({
        for branch in config.branches : branch.name => {
          protection = {
            required_signatures              = try(branch.protection.required_signatures, false)
            enforce_admins                   = try(branch.protection.enforce_admins, false)
            required_linear_history          = try(branch.protection.required_linear_history, true)
            allow_force_pushes               = try(branch.protection.allow_force_pushes, false)
            allow_deletions                  = try(branch.protection.allow_deletions, false)
            block_creations                  = try(branch.protection.block_creations, false)
            required_conversation_resolution = try(branch.protection.required_conversation_resolution, true)
            lock_branch                      = try(branch.protection.lock_branch, false)
            allow_fork_syncing               = try(branch.protection.allow_fork_syncing, false)
            required_pull_request_reviews = {
              dismiss_stale_reviews           = try(branch.protection.dismiss_stale_reviews, true)
              require_code_owner_reviews      = try(branch.protection.require_code_owner_reviews, true)
              require_last_push_approval      = try(branch.protection.require_last_push_approval, true)
              required_approving_review_count = try(branch.protection.required_approving_review_count, 1)
            }
          }
        }
      }, {})
    }
  }

  config = {
    for name, config in local.repo_config : name => {
      topics     = distinct(concat(try(local.repo_common_config.repository.topics, []), try(local.repository_config[name].repository.topics, [])))
      visibility = try(local.repository_config[name].repository.visibility, local.repo_common_config.repository.visibility, "private")
      teams      = merge(try(local.org_config_tf.teams, {}), try(config.teams, {}))
      labels     = merge(try(local.org_config_tf.labels, {}), try(config.labels, {}))
      variables  = merge(try(local.org_config_tf.variables, {}), try(config.variables, {}))
      branches   = merge(try(local.org_config_tf.branches, {}), try(config.branches, {}))
      config = {
        default_branch         = try(local.repository_config[name].repository.default_branch, local.repo_common_config.repository.default_branch, "main")
        archived               = try(local.repository_config[name].repository.archived, local.repo_common_config.repository.archived, false)
        homepage               = try(local.repository_config[name].repository.homepage, local.repo_common_config.repository.homepage, "")
        auto_init              = try(local.repository_config[name].repository.auto_init, local.repo_common_config.repository.auto_init)
        allow_auto_merge       = try(local.repository_config[name].repository.allow_auto_merge, local.repo_common_config.repository.allow_auto_merge)
        allow_merge_commit     = try(local.repository_config[name].repository.allow_merge_commit, local.repo_common_config.repository.allow_merge_commit)
        allow_rebase_merge     = try(local.repository_config[name].repository.allow_rebase_merge, local.repo_common_config.repository.allow_rebase_merge)
        allow_squash_merge     = try(local.repository_config[name].repository.allow_squash_merge, local.repo_common_config.repository.allow_squash_merge)
        allow_update_branch    = try(local.repository_config[name].repository.allow_update_branch, local.repo_common_config.repository.allow_update_branch)
        delete_branch_on_merge = try(local.repository_config[name].repository.delete_branch_on_merge, local.repo_common_config.repository.delete_branch_on_merge)
        has_issues             = try(local.repository_config[name].repository.has_issues, local.repo_common_config.repository.has_issues)
        has_downloads          = try(local.repository_config[name].repository.has_downloads, local.repo_common_config.repository.has_downloads, false)
        has_discussions        = try(local.repository_config[name].repository.has_discussions, local.repo_common_config.repository.has_discussions)
        has_projects           = try(local.repository_config[name].repository.has_projects, local.repo_common_config.repository.has_projects)
        has_wiki               = try(local.repository_config[name].repository.has_wiki, local.repo_common_config.repository.has_wiki)
        security = {
          enableVulnerabilityAlerts    = try(local.repository_config[name].repository.security.enableVulnerabilityAlerts, local.repo_common_config.repository.security.enableVulnerabilityAlerts, true)
          enableAutomatedSecurityFixes = try(local.repository_config[name].repository.security.enableAutomatedSecurityFixes, local.repo_common_config.repository.security.enableAutomatedSecurityFixes, false)
        }
      }
    }
  }
}


module "repository" {
  for_each = local.config

  source = "./modules/repository"

  repository_name = each.key
  description     = try(local.repository_config[each.key].repository.description, "")

  visibility = each.value.visibility
  topics     = each.value.topics

  config = each.value.config

  branches = each.value.branches

  team_access = { for name, permissions in each.value.teams : name => { "team_id" : local.teams_ids[name], "permissions" : permissions } }

  labels = each.value.labels

  variables = {}

}
