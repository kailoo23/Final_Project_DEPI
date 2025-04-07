provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "jpetstore_vm" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io python3-pip
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              pip3 install docker
              EOF

  tags = {
    Name = "JPetStore-VM"
  }
}

resource "aws_security_group" "jpetstore_sg" {
  name        = "jpetstore-sg"
  description = "Security group for JPetStore VM"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your local VM's IP in production
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow app access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.jpetstore_sg.id
  network_interface_id = aws_instance.jpetstore_vm.primary_network_interface_id
}