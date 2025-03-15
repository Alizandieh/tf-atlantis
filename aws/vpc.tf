# Create a VPC
resource "aws_vpc" "saha_vpc" {
  cidr_block           = "121.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "saha-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.saha_vpc.id
  cidr_block              = "121.0.1.0/24"
  availability_zone       = "eu-west-1a" 
  map_public_ip_on_launch = true

  tags = {
    Name = "saha-public-subnet"
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.saha_vpc.id
  cidr_block              = "121.0.2.0/24"
  availability_zone       = "eu-west-1a" 
  map_public_ip_on_launch = false

  tags = {
    Name = "saha-private-subnet"
  }
}

# Create an Internet Gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.saha_vpc.id

  tags = {
    Name = "saha-igw"
  }
}

# Create a public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.saha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "saha-public-route-table"
  }
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a private route table (no NAT Gateway, so no default route)
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.saha_vpc.id

  tags = {
    Name = "saha-private-route-table"
  }
}

# Associate the private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}