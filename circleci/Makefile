export SELF ?= $(MAKE)

SHELL := /bin/bash
var_file_path = "${HOME}/tfvars"

.SHELLFLAGS += -e
.ONESHELL:

## Run terraform init in circleci/admin
circleci/admin/init:
	cd circleci/admin && \
		terraform init

## Run terraform plan in circleci/admin
circleci/admin/plan:
	cd circleci/admin && \
		terraform workspace select circleci_admin && \
			terraform plan -compact-warnings -var-file="${HOME}/tfvars/beantown_circleci.tfvars"

## Run terraform apply in circleci/admin
circleci/admin/apply:
	cd circleci/admin && \
		terraform workspace select circleci_admin && \
			terraform apply -var-file="${HOME}/tfvars/beantown_circleci.tfvars"

## Run a CircleCI destroy in circleci/admin
circleci/admin/destroy:
	cd circleci/admin && \
		terraform workspace select circleci_admin && \
			terraform destroy

## Run terraform init in circleci/beantown
circleci/beantown/init:
	cd circleci/beantown && \
		terraform init

## Run terraform plan in circleci/beantown
circleci/beantown/plan:
	cd circleci/beantown && \
		terraform workspace select circleci_beantown && \
			terraform plan -compact-warnings -var-file="${HOME}/tfvars/beantown_circleci.tfvars"

## Run terraform apply in circleci/beantown
circleci/beantown/apply:
	cd circleci/beantown && \
		terraform workspace select circleci_beantown && \
			terraform apply -var-file="${HOME}/tfvars/beantown_circleci.tfvars"

## Run a CircleCI destroy in circleci/beantown
circleci/beantown/destroy:
	cd circleci/beantown && \
		terraform workspace select circleci_beantown && \
			terraform destroy

## Run terraform init in circleci/menu_api
circleci/menu_api/init:
	cd circleci/menu_api && \
		terraform init

## Run terraform plan in circleci/menu_api
circleci/menu_api/plan:
	cd circleci/menu_api && \
		terraform workspace select circleci_menu_api && \
			terraform plan -compact-warnings

## Run terraform apply in circleci/menu_api
circleci/menu_api/apply:
	cd circleci/menu_api && \
		terraform workspace select circleci_menu_api && \
			terraform apply

## Run a CircleCI destroy in circleci/menu_api
circleci/menu_api/destroy:
	cd circleci/menu_api && \
		terraform workspace select circleci_menu_api && \
			terraform destroy

## Run terraform init in circleci/merch_api
circleci/merch_api/init:
	cd circleci/merch_api && \
		terraform init

## Run terraform plan in circleci/merch_api
circleci/merch_api/plan:
	cd circleci/merch_api && \
		terraform workspace select circleci_merch_api && \
			terraform plan -compact-warnings

## Run terraform apply in circleci/merch_api
circleci/merch_api/apply:
	cd circleci/merch_api && \
		terraform workspace select circleci_merch_api && \
			terraform apply

## Run a CircleCI destroy in circleci/merch_api
circleci/merch_api/destroy:
	cd circleci/merch_api && \
		terraform workspace select circleci_merch_api && \
			terraform destroy
