-include **/Makefile
.PHONY: test
SHELL := /bin/bash
export MAKE_PATH ?= $(shell pwd)
profile ?= ${AWS_PROFILE}

export SELF ?= $(MAKE)

MAKE_FILES = ${MAKE_PATH}/**/Makefile ${MAKE_PATH}/Makefile

.SHELLFLAGS += -e
.ONESHELL: test/apply

## Format Terraform code
fmt:
	terraform fmt --recursive

## Run terraform init in prod/
dev/init:
	cd dev/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in dev/
dev/plan:
	cd dev/ && \
		terraform workspace select dev && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings

## Run a test plan for us-east-2
dev/apply:
	cd dev/ && \
		terraform workspace select dev && \
		aws-vault exec $(profile) -- terraform apply -compact-warnings -var-file=$(var_file)

## Destroy dev resources
dev/destroy:
	cd dev/ && \
		terraform workspace select dev && \
		aws-vault exec $(profile) -- terraform destroy -var-file=$(var_file)

## Run terraform init in prod/
pilot/init:
	cd pilot/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in pilot/
pilot/plan:
	cd pilot/ && \
		terraform workspace select pilot && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings

## Run a test plan for us-east-2
pilot/apply:
	cd pilot/ && \
		terraform workspace select pilot && \
		aws-vault exec $(profile) -- terraform apply -compact-warnings -var-file=$(var_file)

## Destroy pilot resources
pilot/destroy:
	cd pilot/ && \
		terraform workspace select pilot && \
		aws-vault exec $(profile) -- terraform destroy -var-file=$(var_file)

## Run terraform init in prod/
prod/init:
	cd prod/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in prod/
prod/plan:
	cd prod/ && \
		terraform workspace select prod && \
		aws-vault exec $(profile) -- terraform plan -refresh=false -compact-warnings -var-file=$(var_file)

## Run a test plan for us-east-2
prod/apply:
	cd prod/ && \
		terraform workspace select prod && \
		aws-vault exec $(profile) -- terraform apply -var-file=$(var_file)

## Destroy prod resources
prod/destroy:
	cd prod/ && \
		terraform workspace select prod && \
		aws-vault exec $(profile) -- terraform destroy -var-file=$(var_file)

## Run terraform init in dns/
dns/init:
	cd dns/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in dns/
dns/plan:
	cd dns/ && \
		terraform workspace select dns && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings

## Run a test plan for us-east-2
dns/apply:
	cd dns/ && \
		terraform workspace select dns && \
		aws-vault exec $(profile) -- terraform apply

## Run terraform init in tfc/
tfc/init:
	cd tfc/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in tfc/
tfc/plan:
	cd tfc/ && \
		terraform workspace select tfc && \
		aws-vault exec $(profile) -- terraform plan -refresh=false -compact-warnings -var-file=$(var_file)

## Run a test plan for us-east-2
tfc/apply:
	cd tfc/ && \
		terraform workspace select tfc && \
		aws-vault exec $(profile) -- terraform apply -var-file=$(var_file)

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
	{ lastLine = $$0 }' $(MAKE_FILES) | sort -u
	@printf "\n\n"
