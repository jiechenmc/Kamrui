terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "minecraft" {
  ingress {
    description = "Receive SSH from home."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Receive Minecraft from everywhere."
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Send everywhere."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Minecraft"
  }
}

resource "aws_key_pair" "home" {
  key_name   = "Home"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCryHrAiznFHtk70ybiM1AvuXyTR5X7u3eqSzxznTuQlAZJqB6h1N3MH5csn8llup8nA44FQ2A5AfIG2D8/NbtWUikzZJiU7EUw2L1njOEeeqrY8CvOf94IrDty9nEXCjTgtsutdf/992U5UQj0r2c3DcmvDD54xwPfAG9KBRMdWjvH1bwMBSLsSt9gnviAc9QoPxPnR7bnqbK2XGGsDGjHfHbXq/1TGNaa8fKEf0eiriQg+v03lPUmTeJg8l4Pb/brDXo0FtHUzg8iiAxg6y+Ni9dk1iqn0CN1zkyduL1e4Nf4qT85fQH3GA+FSjbG60UNhGNv2TWnD/8FtiaNQL5uHybMsbk3Oiu2hE0RiYKOMWUvcbxk8AuGszE3wuMWMvSjGPO64sxDN4F5CqEHv1dc4TQ9YCL9P2PTUswJWKFiBo4EbLr8X5Igv+4YZ//x/+WI8oQnU2uz1UmrtHCXjb2T3F9heEMbMUb4INuxZ716oz1wPWgb6mzCHqRi1N8/jTs= chenj7728@DESKTOP-LKJ3I25"
}

resource "aws_instance" "minecraft" {
  ami                         = "ami-0c7217cdde317cfec"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.minecraft.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.home.key_name
  tags = {
    Name = "Minecraft"
  }
}

output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}
