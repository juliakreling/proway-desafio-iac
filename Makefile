IMAGE_NAME = docker-jewelry-app
PORT_LOCAL = 80
PORT_CONTAINER = 8080

# 1. Fluxo Terraform (infra AWS)

default: aws-deploy

init:
	terraform init 

fmt: init
	terraform fmt 

plan: fmt
	terraform plan 

apply: plan
	terraform apply -auto-approve

aws-deploy: apply
	@echo "[INFO] Aguarde alguns minutos para a aplicação inicializar..."

aws-destroy:
	terraform destroy -auto-approve

# 2. Fluxo local / EC2

build:
	npm install
	npm run build

docker-build: build
	docker build -t $(IMAGE_NAME) .

docker-run: docker-build
	@docker rm -f $(IMAGE_NAME) >/dev/null 2>&1 || true
	docker run -d -p $(PORT_LOCAL):$(PORT_CONTAINER) --name $(IMAGE_NAME) $(IMAGE_NAME)
	@echo "[INFO] Aplicação rodando em http://localhost:$(PORT_LOCAL)"

setup: docker-run

clean:
	@echo "[INFO] Limpando artefatos..."
	rm -rf node_modules dist .terraform terraform.tfstate* tfplan
	@docker rm -f $(IMAGE_NAME) >/dev/null 2>&1 || true
	@docker rmi $(IMAGE_NAME) >/dev/null 2>&1 || true


