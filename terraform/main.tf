# main.tf
# Create my instance and other resource on Amazon
# Define the AWS provider

provider "aws" {
  region = "eu-central-1" # Specify AWS region
}

#Create a security group
resource "aws_security_group" "sg_myserv001" {
  name        = "sg_myserv001"
  description = "My security group for instance 001"

  # Ingress rules
  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rules
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_myserv001"
  }
}

#Create an instanse Ubuntu
resource "aws_instance" "myserver001" {
  ami             = "ami-01e444924a2233b07"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg_myserv001.name]
  key_name        = "Key_myfirstserver"
  user_data       = file("user_data.sh")

  tags = {
    Name = "My_serv001_Ubuntu"
  }
}

# Outputs
output "instance_id" {
  description = "The ID of the myserv001 instance"
  value       = aws_instance.myserver001.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.myserver001.public_ip
}
