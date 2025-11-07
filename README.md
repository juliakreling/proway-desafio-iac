# Jewelry App

Aplicação Vue.js para exibição de joias com deploy automatizado na AWS utilizando Terraform.

## Pré-requisitos

- Node.js 18+
- Docker
- Terraform

## Execução Local

### Docker Local

```bash
# Usando Makefile
make docker-run

# Ou manualmente
docker build -t jewelry-app .
docker run jewelry-app
```

Acesse: http://localhost:8080

## Deploy na AWS

### Configuração Inicial

```bash
export AWS_ACCESS_KEY_ID="sua-access-key"
export AWS_SECRET_ACCESS_KEY="sua-secret-key"
export AWS_DEFAULT_REGION="sua região padrão"
```

### Deploy Automatizado

```bash
# Deploy completo (build + infraestrutura + aplicação)
make aws-deploy
```

### Deploy Manual

```bash
# 1. Inicializar Terraform
make init

# 2. Planejar mudanças
make plan

# 3. Aplicar infraestrutura
make apply

# 4. Build e deploy da aplicação
make deploy
```

## Comandos Úteis

```bash
# Build da aplicação
make build

# Limpar arquivos temporários
make clean

# Destruir infraestrutura Azure
make aws-destroy
```

## Infraestrutura AWS

O Terraform provisiona:

- VM EC2 com Docker
- IP Público

A aplicação roda na porta 8080 da EC2.
