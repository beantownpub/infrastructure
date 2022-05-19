
SHELL := /bin/bash
.SHELLFLAGS += -e
.ONESHELL:

profile ?= ${AWS_PROFILE}

## Run terraform init in grafana/
grafana/init:
	cd grafana/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in grafana/
grafana/plan:
	cd grafana/ && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings

## Run terraform apply in grafana/
grafana/apply:
	cd grafana/ && \
		aws-vault exec $(profile) -- terraform apply -compact-warnings

## Destroy grafana resources
grafana/destroy:
	cd grafana/ && \
		aws-vault exec $(profile) -- terraform destroy
