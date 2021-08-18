
aws_profile ?= ${AWS_PROFILE}
env ?= dev

var_file = ${PWD}/modules/vpc/vpc.tfvars

init:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) init -backend-config=backend.hcl

plan:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) plan

apply:
		aws-vault exec beantown -- terraform -chdir=$(env) apply
