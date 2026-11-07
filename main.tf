# Fetch the default VPC
data "aws_vpc" "terraform" {
  default = true
}

# Fetch subnets belonging to the default VPC
data "aws_subnets" "terraform_sub" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.terraform.id]
  }
}

# Dynamically fetch the latest official Ubuntu 24.04 AMI in the configured region (ap-south-1)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group allowing SSH and all outbound traffic
resource "aws_security_group" "ec2_sg" {
  name        = "terraform-ec2-sg"
  description = "Security group for Terraform EC2"
  vpc_id      = data.aws_vpc.terraform.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-ec2-sg"
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = data.aws_subnets.terraform_sub.ids[0]

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = var.instance_name
  }
}