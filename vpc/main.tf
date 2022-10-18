
#Defining the VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "dev-vpc"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "dev-igw"
  }
}
/*
#Attaching Internet Gateway to VPC
resource "aws_internet_gateway_attachment" "igw-attach-vpc" {
  internet_gateway_id = aws_internet_gateway.dev-igw.id
  vpc_id              = aws_vpc.dev-vpc.id
}
*/
#Create Public Route Table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

#Create Private Route Table
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
      nat_gateway_id = aws_nat_gateway.my-test-nat-gateway.id
      cidr_block     = "0.0.0.0/0"
  }
  tags = {
    Name = "private-route-table"
  }
}

#Create Public Subnet
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.public-subnet[count.index]
  map_public_ip_on_launch = true
  count = 2
  availability_zone = var.az[count.index]
  tags = {
    Name = "public-subnet.${count.index + 1}"
  }
}

#Create Private Subnet
resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.private-subnet[count.index]
  count = 2
  availability_zone = var.az[count.index]
  tags = {
    Name = "private-subnet.${count.index + 1}"
  }
}

resource "aws_eip" "my-test-eip" {
  vpc = true
}

#Create NAT Gateway
resource "aws_nat_gateway" "my-test-nat-gateway" {
  allocation_id = aws_eip.my-test-eip.id
  subnet_id     = aws_subnet.public-subnet.0.id
}

#Create database Subnet
resource "aws_subnet" "db-private-subnet" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.db-private-subnet[count.index]
  count = 2
  availability_zone = var.az[count.index]
  tags = {
    Name = "db-private-subnet.${count.index + 1}"
  }
}

#Associate Public Subnet with Public Route

resource "aws_route_table_association" "public-subnet-assoc" {
  count = 2
  subnet_id      = aws_subnet.public-subnet.*.id[count.index]
  route_table_id = aws_route_table.public-route-table.id
  depends_on = ["aws_route_table.public-route-table", "aws_subnet.public-subnet"]
}

#Associate Private Subnet with Public Route

resource "aws_route_table_association" "private-subnet-assoc" {
  count = 2
  subnet_id      = aws_subnet.private-subnet.*.id[count.index]
  route_table_id = aws_route_table.private-route-table.id
  depends_on = ["aws_route_table.private-route-table", "aws_subnet.private-subnet"]
}

#Create Security Group
resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-sg"
  }
}

/*
#Security Group Rule

resource "aws_security_group_rule" "allow-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "aws_security_group.dev-sg.id"
}
resource "aws_security_group_rule" "allow-http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "aws_security_group.dev-sg.id"
}
*/








