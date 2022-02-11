
SHELL := /bin/bash
.SHELLFLAGS += -e
.ONESHELL:

profile ?= ${AWS_PROFILE}

## Run terraform init in prod/
tailscale/init:
	cd tailscale/ && \
		aws-vault exec $(profile) -- terraform init

## Run terraform plan in tailscale/
tailscale/plan:
	cd tailscale/ && \
		terraform workspace select tailscale && \
		aws-vault exec $(profile) -- terraform plan -compact-warnings -var-file=$(var_file)

## Run a test plan for us-east-2
tailscale/apply:
	cd tailscale/ && \
		terraform workspace select tailscale && \
		aws-vault exec $(profile) -- terraform apply -compact-warnings -var-file=$(var_file)

## Destroy tailscale resources
tailscale/destroy:
	cd tailscale/ && \
		terraform workspace select tailscale && \
		aws-vault exec $(profile) -- terraform destroy -var-file=$(var_file)
