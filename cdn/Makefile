
SHELL := /bin/bash
.SHELLFLAGS += -e
.ONESHELL:

profile ?= ${AWS_PROFILE}

## Run terraform init in prod/
cdn/init:
	cd cdn/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in cdn/
cdn/plan:
	cd cdn/ && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings

## Run a test plan for us-east-2
cdn/apply:
	cd cdn/ && \
		aws-vault exec $(profile) -- terraform apply -compact-warnings

## Destroy cdn resources
cdn/destroy:
	cd cdn/ && \
		aws-vault exec $(profile) -- terraform destroy
