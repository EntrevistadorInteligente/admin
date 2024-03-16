include terraform.mk

# Variables

terraform_project_cmd = $(if $(wildcard ./terraform.sh),./terraform.sh,terraform)

# Alias

.PHONY: p a aa
p: lint plan
a: lint apply
aa: lint apply-approve

# Targets

.PHONY: plan
plan: ## Plan the infrastructure changes
	$(terraform_project_cmd) plan

.PHONY: apply
apply: ## Apply the infrastructure changes
	$(terraform_project_cmd) apply

.PHONY: apply-approve
apply-approve: ## Auto apply the infrastructure changes
	$(terraform_project_cmd) apply -auto-approve

.PHONY: console
console: ## Open the terraform console
	$(terraform_project_cmd) console

move: ## move resource
	$(terraform_project_cmd) state mv \
		'github_branch_default.admin' 'module.admin.github_branch_default.main'
	$(terraform_project_cmd) state mv \
			'github_branch_protection.admin' 'module.admin.github_branch_protection.main'
	$(terraform_project_cmd) state mv \
			'github_repository.admin' 'module.admin.github_repository.main'

ci: ## ci
	$(terraform_project_cmd) init
	$(terraform_project_cmd) fmt -check
	$(terraform_project_cmd) plan -input=false

cd: ## cd
	$(terraform_project_cmd) apply -auto-approve -input=false
