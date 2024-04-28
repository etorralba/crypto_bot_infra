include .env
SHELL := /bin/bash

load_env:
	@echo "Loading environment variables..."
	set -a; source .env; set +a
	@echo "Done!"

init:
	@echo "Initializing..."
	@make load_env
	@cd terraform && terraform init -reconfigure\
		-backend-config="bucket=${TF_STATE_BUCKET}"\
		-backend-config="key=${TF_VAR_environment}/terraform.tfstate"\
		-backend-config="region=${TF_VAR_aws_region}"	
	@echo "Done!"

plan:
	@echo "Planning..."
	@make load_env
	@cd terraform && terraform plan
	@echo "Done!"


apply:
	@echo "Applying..."
	@make load_env
	@cd terraform && terraform apply -auto-approve
	@echo "Done!"
	@echo "Saving key..."
	@rm -f  ~/.ssh/${TF_VAR_environment}_ec2_admin_key.pem
	@cd terraform && terraform output -raw private_key_pem > ~/.ssh/${TF_VAR_environment}_ec2_admin_key.pem
	@chmod 400  ~/.ssh/${TF_VAR_environment}_ec2_admin_key.pem

destroy:
	@echo "Destroying..."
	@cd terraform && terraform destroy -auto-approve
	@echo "Done!"

connect:
	@echo "Connecting..."
	cd terraform && ssh -i ~/.ssh/${TF_VAR_environment}_ec2_admin_key.pem ubuntu@$$(terraform output -raw instance_public_dns)
	@echo "Done!"

.PHONY: ansible
ansible:
	@echo "Ping servers..."
	ansible -i ./ansible/inventory.ini  servers -m ping
	@echo "Install docker..."
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbooks/install-docker.yml
	@echo "Install docker-compose..."
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbooks/install-docker-compose.yml
	@echo "Setup Freqtrade..."
	ansible-playbook -i ./ansible/inventory.ini ./ansible/playbooks/setup-freqtrade.yml
	@echo "Done!"
