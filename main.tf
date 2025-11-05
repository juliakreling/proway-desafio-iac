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
    apt update -y
    apt install -y docker.io git unzip curl
    systemctl enable docker
    systemctl start docker
    cd /home/admin 2>/dev/null || cd /root
    git clone https://github.com/juliakreling/proway-desafio-iac.git app
    cd app

    docker build -t docker-joalheria .
    docker run docker-joalheria 
    EOF

}


