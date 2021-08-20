
aws_profile ?= ${AWS_PROFILE}
env ?= dev

init:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) init -input=false

plan:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) plan -lock=false

apply:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) apply

destroy:
		aws-vault exec $(aws_profile) -- terraform -chdir=$(env) destroy

clean:
		rm -rf $(env)/.terraform || true
