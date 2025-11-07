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
    apt install -y docker.io git make unzip curl

    # Habilita e inicia o Docker
    echo "[INFO] Habilitando e iniciando Docker..."
    systemctl enable docker
    systemctl start docker

    # Acessa diretório padrão
    cd /home/admin 2>/dev/null || cd /home/ubuntu 2>/dev/null || cd /root

    # Clona o repositório se ainda não existir
    if [ ! -d "proway-desafio-iac" ]; then
      echo "[INFO] Clonando repositório..."
      git clone https://github.com/juliakreling/proway-desafio-iac.git
    fi

    cd proway-desafio-iac

    # Atualiza o repositório e executa o Makefile
    echo "[INFO] Atualizando repositório e executando Makefile..."
    git pull
    make setup

    echo "[INFO] Setup concluído com sucesso!"
  EOF
}
