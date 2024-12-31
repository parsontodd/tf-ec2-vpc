locals {
  common_tags = {
    ManagedBy = "terraform-parson"
  }
}
resource "aws_vpc" "parson_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = merge(local.common_tags, {
    Name = "parson-vpc"
  })
}

resource "aws_subnet" "parson_public_subnet" {
  vpc_id     = aws_vpc.parson_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = merge(local.common_tags, {
    Name = "parson-public"
  })
}

resource "aws_subnet" "parson_private_subnet" {
  vpc_id     = aws_vpc.parson_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = merge(local.common_tags, {
    Name = "parson-private"
  })
}

resource "aws_internet_gateway" "parson_igw" {
  vpc_id = aws_vpc.parson_vpc.id

  tags = merge(local.common_tags, {
    Name = "parson-igw"
  })
}

resource "aws_route_table" "parson_public_rtb" {
  vpc_id = aws_vpc.parson_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.parson_igw.id
  }

  tags = merge(local.common_tags, {
    Name = "parson-main-rtb"
  })
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.parson_public_subnet.id
  route_table_id = aws_route_table.parson_public_rtb.id
}