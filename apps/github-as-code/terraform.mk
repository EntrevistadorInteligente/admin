GIT_ROOT := $(shell git rev-parse --show-toplevel)
include $(GIT_ROOT)/.makefiles/help.mk

.DEFAULT_GOAL := all

# Targets

.PHONY: all
all: lint

.PHONY: clean
clean: ## Clean secrets files
	@-rm -r *-secrets.tfvars
	@-rm -r *.tfstate

.PHONY: init
init: ## Initialize Terraform
	terraform init --upgrade

.PHONY: check
check: ## Check Terraform files
	terraform fmt -check=true -diff=true
.PHONY: lint
lint: format validate ## Lint Terraform files
.PHONY: format
format: init ## Format Terraform files
	terraform fmt -write=true
.PHONY: validate
validate: init ## Validate Terraform files
	terraform validate
