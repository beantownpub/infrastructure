
.PHONY: test
SHELL := /bin/bash

profile ?= ${AWS_PROFILE}

export SELF ?= $(MAKE)

.SHELLFLAGS += -e
.ONESHELL: test/apply

## Format Terraform code
fmt:
	terraform fmt --recursive

## Run terraform init in prod/
prod/init:
	cd prod/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in prod/
prod/plan:
	cd prod/ && \
		terraform workspace select development && \
		aws-vault exec $(profile) -- terraform plan -refresh=false -compact-warnings

## Run a test plan for us-east-2
prod/apply:
	cd prod/ && \
		terraform workspace select development && \
		aws-vault exec $(profile) -- terraform apply

## Destroy prod resources
prod/destroy:
	cd prod/ && \
		terraform workspace select development && \
		aws-vault exec $(profile) -- terraform destroy

## Show available commands
help:
	@printf "Available targets:\n\n"
	@$(SELF) -s help/generate | grep -E "\w($(HELP_FILTER))"

help/generate:
	@awk '/^[a-zA-Z\_0-9%:\\\/-]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' Makefile | sort -u
	@printf "\n\n"
