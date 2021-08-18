
aws_profile ?= ${AWS_PROFILE}
env ?= dev

init:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) init

plan:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) plan

apply:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) apply

destroy:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) destroy
