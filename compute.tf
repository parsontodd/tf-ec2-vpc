resource "aws_instance" "parson_web" {
  ami                         = "ami-0c601162231abbc5a"
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.parson_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.allow_http_traffic.id]

  tags = merge(local.common_tags, {
    Name = "parson-ec2"
  })
}

resource "aws_security_group" "allow_http_traffic" {
  name        = "public-http-traffic"
  description = "Allow HTTP and HTTPS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.parson_vpc.id

  tags = merge(local.common_tags, {
    Name = "parson-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.allow_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags
}