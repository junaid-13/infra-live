.PHONY: init plan apply fmt validate
init: ; terraform -chdir=envs/dev init
plan: ; terraform -chdir=envs/dev plan
apply: ; terraform -chdir=envs/dev apply -auto-approve
fmt: ; terraform -chdir=envs/dev fmt -recursive
validate: ; terraform -chdir=envs/dev init -backend=false && terraform -chdir=envs/dev validate