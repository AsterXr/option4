resource "aws_vpc" "option4-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "option4"
  }
}

resource "aws_internet_gateway" "option4-gw" {
  count  = var.debug ? 1 : 0
  vpc_id = aws_vpc.option4-vpc.id
  tags = {
    Name = "option4-gw"
  }
}

resource "aws_route_table" "option4-pubrt" {
  count  = var.debug ? 1 : 0
  vpc_id = aws_vpc.option4-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.option4-gw[0].id
  }
  tags = {
    Name = "option4-pubrt"
  }
}

resource "aws_subnet" "option4-pubnet" {
  count      = var.debug ? 1 : 0
  vpc_id     = aws_vpc.option4-vpc.id
  cidr_block = local.pub_cidr_block
  tags = {
    Name = "option4-pubnet"
  }
  depends_on = [aws_internet_gateway.option4-gw]
}

resource "aws_subnet" "option4-privnet" {
  count      = var.debug ? 0 : 1
  vpc_id     = aws_vpc.option4-vpc.id
  cidr_block = local.priv_cidr_block
  tags = {
    Name = "option4-privnet"
  }
}

resource "aws_route_table_association" "option4-pubnet-assoc-pubnet" {
  count          = var.debug ? 1 : 0
  subnet_id      = aws_subnet.option4-pubnet[0].id
  route_table_id = aws_route_table.option4-pubrt[0].id
}

resource "aws_security_group" "option4-sg" {
  name        = "option4-sg"
  description = "Security group"
  vpc_id      = aws_vpc.option4-vpc.id

}

resource "aws_security_group_rule" "option4-sg-rule-22" {
  count             = var.debug == true ? 1 : 0
  security_group_id = aws_security_group.option4-sg.id
  type              = "ingress"
  description       = "IN FROM MGMT - SSH MGMT"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "option4-sg-rule-31555" {
  security_group_id = aws_security_group.option4-sg.id
  type              = "ingress"
  description       = "IN FROM MGMT - 31555 MGMT"
  from_port         = "31555"
  to_port           = "31555"
  protocol          = "tcp"
  cidr_blocks       = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "option4-sg-rule-egress" {
  security_group_id = aws_security_group.option4-sg.id
  type              = "egress"
  description       = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}
