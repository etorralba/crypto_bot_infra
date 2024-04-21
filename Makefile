SHELL := /bin/bash

load_env:
	@echo "Loading environment variables..."
	@set -a; source .env; set +a
	@echo "Done!"

init:
	@echo "Initializing..."
	@make load_env
	@cd terraform && terraform init
	@echo "Done!"

plan:
	@echo "Planning..."
	@cd terraform && terraform plan
	@echo "Done!"

apply:
	@echo "Applying..."
	@cd terraform && terraform apply -auto-approve
	@echo "Done!"
	@echo "Saving key..."
	@rm -f  ~/.ssh/admin_key.pem
	cd terraform && terraform output -raw private_key_pem > ~/.ssh/admin_key.pem
	@chmod 400  ~/.ssh/admin_key.pem

destroy:
	@echo "Destroying..."
	@cd terraform && terraform destroy -auto-approve
	@echo "Done!"

connect:
	@echo "Connecting..."
	@cd terraform && ssh -i ~/.ssh/admin_key.pem ubuntu@$$(terraform output -raw instance_public_dns)
	@echo "Done!"
