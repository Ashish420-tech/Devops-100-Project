provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "assignment01_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "assignment01-vpc"
  }
}

resource "aws_subnet" "assignment01_subnet" {
  vpc_id                  = aws_vpc.assignment01_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "assignment01-subnet"
  }
}

resource "aws_internet_gateway" "assignment01_igw" {
  vpc_id = aws_vpc.assignment01_vpc.id

  tags = {
    Name = "assignment01-igw"
  }
}

resource "aws_route_table" "assignment01_rt" {
  vpc_id = aws_vpc.assignment01_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.assignment01_igw.id
  }

  tags = {
    Name = "assignment01-rt"
  }
}

resource "aws_route_table_association" "assignment01_rta" {
  subnet_id      = aws_subnet.assignment01_subnet.id
  route_table_id = aws_route_table.assignment01_rt.id
}

resource "aws_security_group" "assignment01_sg" {
  name        = "assignment01-jenkins-sg"
  description = "Security group for Jenkins"
  vpc_id      = aws_vpc.assignment01_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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
    Name = "assignment01-sg"
  }
}

resource "aws_instance" "jenkins_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.assignment01_subnet.id
  vpc_security_group_ids      = [aws_security_group.assignment01_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "assignment01-jenkins-server"
  }
}
