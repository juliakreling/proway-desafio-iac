default: aws-deploy
init:
	terraform init

plan: init
	terraform plan

apply: plan
	terraform apply -auto-approve

build:
	npm install
	npm run build

clean:
	rm -rf node_modules dist .terraform terraform.tfstate*

docker-build:
	docker build -t docker-jewelry-app .

docker-run: docker-build
	docker run -p 8080:80 docker-jewelry-app

aws-deploy: apply
	@echo "Aguarde alguns minutos para a aplicação inicializar..."
	@echo "URL: http://$$(terraform output -raw vm_public_ip):8080"

aws-destroy:
	terraform destroy -auto-approve
