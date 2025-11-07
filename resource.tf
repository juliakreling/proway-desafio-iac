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
    exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

    echo "[INFO] Iniciando configuração da instância Debian..."

    # Atualiza pacotes e instala dependências
    echo "[INFO] Atualizando pacotes..."
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg git make unzip docker.io

    # Instala Node.js 18 (via NodeSource)
    echo "[INFO] Instalando Node.js 18..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs

    # Verifica versões instaladas
    echo "[INFO] Versões instaladas:"
    node -v
    npm -v
    docker -v

    # Habilita e inicia o Docker
    echo "[INFO] Habilitando e iniciando Docker..."
    systemctl enable docker
    systemctl start docker

    # Define diretório de trabalho
    cd /root

    # Clona o repositório se ainda não existir
    if [ ! -d "proway-desafio-iac" ]; then
      echo "[INFO] Clonando repositório..."
      git clone https://github.com/juliakreling/proway-desafio-iac.git
    else
      echo "[INFO] Repositório já existe. Atualizando..."
      cd proway-desafio-iac
      git pull
      cd ..
    fi

    # Acessa o diretório do projeto
    cd proway-desafio-iac

    # Dá permissão de execução se necessário
    chmod +x Makefile 2>/dev/null || true

    # Executa o Makefile
    echo "[INFO] Executando make setup..."
    make setup || echo "[WARN] Falha ao executar make setup"

    echo "[INFO] Setup concluído com sucesso!"
  EOF

}

