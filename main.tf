terraform {

  required_version = ">=1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      owner      = "juliakreling"
      managed-by = "terraform"
    }
  }
}

resource "aws_instance" "instance_jewerly" {
  ami                         = "ami-0b0012dad04fbe3d7" # Debian AMI
  instance_type               = "t2.micro"
  key_name                    = "julia-key"                # essa key ja esta criada na AWS
  vpc_security_group_ids      = ["sg-09ecede5dfa7f56dd"]   # security group ja criado na AWS
  subnet_id                   = "subnet-0306135ddda99d608" # subnet ja criada na AWS
  associate_public_ip_address = true

  tags = {
    Name = "instance-julia-jewelry"
  }

  user_data = <<-EOF
    #!/bin/bash
    set -e

    echo "[INFO] Iniciando configuração da instância Debian..."

    # Atualiza pacotes e instala dependências
    echo "[INFO] Atualizando pacotes..."
    apt update -y
    apt install -y docker.io git unzip curl

    # Habilita e inicia o Docker
    echo "[INFO] Habilitando e iniciando Docker..."
    systemctl enable docker
    systemctl start docker

    # Acessa diretório padrão
    cd /home/admin 2>/dev/null || cd /home/ubuntu 2>/dev/null || cd /root

    # Clona ou atualiza o repositório
    echo "[INFO] Clonando repositório..."
    if [ -d "proway-desafio-iac" ]; then
      echo "[INFO] Repositório já existe. Atualizando..."
      cd proway-desafio-iac
      git pull
    else
      git clone https://github.com/juliakreling/proway-desafio-iac.git
      cd proway-desafio-iac
    fi

    # Constrói a imagem Docker
    echo "[INFO] Construindo imagem Docker..."
    docker build -t docker-joalheria .

    # Executa o container (porta 80)
    echo "[INFO] Iniciando container..."
    docker run -d -p 80:80 docker-joalheria

    echo "[INFO] Setup concluído com sucesso!"
    EOF

}


