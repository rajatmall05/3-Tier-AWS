# VPC -----------------------------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "Three-Tier-VPC-Test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Three-Tier-VPC-Test"
  }
}

# SUBNET -------------------------------------------------------------------------------------------------------------------------------------

# 1 Public-Subnet-FE
resource "aws_subnet" "Public-Subnet-AZ1" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Public-Subnet-AZ1"
  }
}

# 2 Public-Subnet-FE
resource "aws_subnet" "Public-Subnet-AZ2" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Public-Subnet-AZ2 "
  }
}

# 3 Private-Subnet-BE
resource "aws_subnet" "Private-Subnet-AZ1" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-Subnet-AZ1"
  }
}

# 4 Private-Subnet-BE
resource "aws_subnet" "Private-Subnet-AZ2" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Private-Subnet-AZ2"
  }
}

# 5 Private-Subnet-DB
resource "aws_subnet" "Private-DB-Subnet-AZ1" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Private-DB-Subnet-AZ1"
  }
}

# 6 Private-Subnet-DB
resource "aws_subnet" "Private-DB-Subnet-AZ2" {
  vpc_id            = aws_vpc.Three-Tier-VPC-Test.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Private-DB-Subnet-AZ2"
  }
}



# INTERNET-GATEWAY ---------------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "Three-Tier-IGW" {
  vpc_id = aws_vpc.Three-Tier-VPC-Test.id

  tags = {
    Name = "Three-Tier-IGW"
  }
}

# NAT-GATEWAY - 1 -----------------------------------------------------------------------------------------------------------------------------

resource "aws_nat_gateway" "Nat_Gateway_AZ1" {
  allocation_id = aws_eip.Nat_eip_AZ1.id
  subnet_id     = aws_subnet.Public-Subnet-AZ1.id

  tags = {
    Name = "Three-Tier-NatGateway-1"
  }
}

# Elastic Ip for NAT-GATEWAY-1 

resource "aws_eip" "Nat_eip_AZ1" {
  vpc = true
  tags = {
    Name = "NAT-EIP-AZ1"
  }
}

# NAT-GATEWAY - 2 --------------------------------------------------------------------------------------------------------------------------

resource "aws_nat_gateway" "Nat_Gateway_AZ2" {
  allocation_id = aws_eip.Nat_eip_AZ2.id
  subnet_id     = aws_subnet.Public-Subnet-AZ2.id

  tags = {
    Name = "Three-Tier-NatGateway-2"
  }
}

# Elastic Ip for NAT-GATEWAY-2 

resource "aws_eip" "Nat_eip_AZ2" {
  vpc = true
  tags = {
    Name = "NAT-EIP-AZ2"
  }
}

# ROUTE - TABLE - PUBLIC -------------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "Public-Route-Table" {
  vpc_id = aws_vpc.Three-Tier-VPC-Test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Three-Tier-IGW.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

# SUBNET - ASSOCIATE

resource "aws_route_table_association" "Public-Subnet-Associate-AZ1" {
  subnet_id      = aws_subnet.Public-Subnet-AZ1.id
  route_table_id = aws_route_table.Public-Route-Table.id
}

resource "aws_route_table_association" "Public-Subnet-Associate-AZ2" {
  subnet_id      = aws_subnet.Public-Subnet-AZ2.id
  route_table_id = aws_route_table.Public-Route-Table.id
}

# ROUTE - TABLE - PRIVATE-AZ1 ---------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "Private-Nat-Route-Table-AZ1" {
  vpc_id = aws_vpc.Three-Tier-VPC-Test.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_Gateway_AZ1.id
  }
  tags = {
    Name = "Private-Nat-Route-Table-AZ1"
  }
}

# SUBNET - ASSOCIATE

resource "aws_route_table_association" "Private-Subnet-Associate-AZ1" {
  subnet_id      = aws_subnet.Private-Subnet-AZ1.id
  route_table_id = aws_route_table.Private-Nat-Route-Table-AZ1.id
}


# ROUTE - TABLE - PRIVATE-AZ2 --------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "Private-Nat-Route-Table-AZ2" {
  vpc_id = aws_vpc.Three-Tier-VPC-Test.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Nat_Gateway_AZ2.id
  }
  tags = {
    Name = "Private-Nat-Route-Table-AZ2"
  }
}

# SUBNET - ASSOCIATE

resource "aws_route_table_association" "Private-Subnet-Associate-AZ2" {
  subnet_id      = aws_subnet.Private-Subnet-AZ2.id
  route_table_id = aws_route_table.Private-Nat-Route-Table-AZ2.id
}

# SECURITY - GROUP --------------------------------------------------------------------------------------------------------------------------

# (1) External Load Balancer SG

resource "aws_security_group" "External-Load-Balancer-sg" {
  name        = "External-Load-Balancer-sg"
  description = "Allow TExternal-Load-Balancer inbound traffic"
  vpc_id      = aws_vpc.Three-Tier-VPC-Test.id

  ingress {
    description = "ELB from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Three-Tier-VPC-Test.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow External-Load-Balancer inbound traffic"
  }
}

# (2) Internal Load Balancer SG

resource "aws_security_group" "Internal-Load-Balancer-sg" {
  name        = "Internal-Load-Balancer-sg"
  description = "Allow Internal-Load-Balancer-sg inbound traffic"
  vpc_id      = aws_vpc.Three-Tier-VPC-Test.id

  ingress {
    description = "ILB from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Three-Tier-VPC-Test.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow Internal-Load-Balancer inbound traffic"
  }
}

# (3) Public EC2 SG

resource "aws_security_group" "Public-EC2-sg" {
  name        = "Public-EC2-sg"
  description = "Allow Public-EC2-sg inbound traffic"
  vpc_id      = aws_vpc.Three-Tier-VPC-Test.id

  ingress {
    description = "Public-EC2 from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Three-Tier-VPC-Test.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow Public EC2"
  }
}

# (4) Private EC2 SG

resource "aws_security_group" "Private-EC2-sg" {
  name        = "Private-EC2-sg"
  description = "Allow Private-EC2-sg inbound traffic"
  vpc_id      = aws_vpc.Three-Tier-VPC-Test.id

  ingress {
    description = "Private-EC2 from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Three-Tier-VPC-Test.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow Private EC2"
  }
}

# (5) DBMS SG

resource "aws_security_group" "DBMS-sg" {
  name        = "DBMS-sg"
  description = "Allow DBMS-sg inbound traffic"
  vpc_id      = aws_vpc.Three-Tier-VPC-Test.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.Three-Tier-VPC-Test.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Allow DBMS"
  }
}



 # CREATING EC2 ------------------------------------------------------------------------------------------------------------------------------

# resource "aws_instance" "private_ec2"{
#     ami = var.aws_ami_pri
#     instance_type = var.inst_type
#     key_name = var.key_name
#     monitoring = var.monit_inst
#     vpc_security_group_ids = [var.vpc_sg_pri]
#     iam_instance_profile = var.iam_inst
#     subnet_id = var.pri_sub
#     tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
#     #user_data = file("install_mysql.sh")
# }

# resource "aws_instance" "public_ec2"{
#     ami = var.aws_ami_pub
#     instance_type = var.inst_type
#     key_name = var.key_name
#     monitoring = var.monit_inst
#     vpc_security_group_ids = [var.vpc_sg_pub]
#     iam_instance_profile = var.iam_inst
#     subnet_id = var.pub_sub
#     associate_public_ip_address = var.public_ip
#     tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
#     #user_data = file("install_nginx.sh")
#     depends_on = [aws_instance.private_ec2]
# }